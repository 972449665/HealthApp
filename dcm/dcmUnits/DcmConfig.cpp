#include "dcmtk/config/osconfig.h"    /* make sure OS specific configuration is included first */
#include "dcmconfig.h"

/* includes */
#define INCLUDE_CSTDIO
#define INCLUDE_CCTYPE
#define INCLUDE_CSTDARG
#define INCLUDE_CSTRING
#include "dcmtk/ofstd/ofstdinc.h"
#include "dcmtk/ofstd/ofcmdln.h"
#include "dcmtk/ofstd/ofmap.h"
#include "dcmtk/ofstd/ofchrenc.h"

OFLogger DCM_dcmqrdbLogger = OFLog::getLogger("dcmtk.dcmUnits");

static void freePeer(OFMap<const void *, OFBool> &pointersToFree, struct DcmConfigFilePeer *entry)
{
    // Hack to make sure we don't double-free
    pointersToFree[entry->ApplicationTitle] = OFTrue;
    pointersToFree[entry->HostName] = OFTrue;
}

static void freeConfigAEEntry(OFMap<const void *, OFBool> &pointersToFree, struct DcmConfigFileAEEntry *entry)
{
    for (int i = 0; i < entry->noOfPeers; i++) {
        freePeer(pointersToFree, &entry->Peers[i]);
    }
    free(OFconst_cast(char *, entry->ApplicationTitle));
    free(OFconst_cast(char *, entry->StorageArea));
    free(OFconst_cast(char *, entry->Access));
    free(entry->StorageQuota);
    free(entry->Peers);
}

static void freeConfigHostEntry(OFMap<const void *, OFBool> &pointersToFree, struct DcmConfigFileHostEntry *entry)
{
    for (int i = 0; i < entry->noOfPeers; i++) {
        freePeer(pointersToFree, &entry->Peers[i]);
    }
    free(OFconst_cast(char *, entry->SymbolicName));
    free(entry->Peers);
}

DcmQueryRetrieveCharacterSetOptions::DcmQueryRetrieveCharacterSetOptions()
    : characterSet()
    , flags(0)
    , conversionFlags(0)
{

}

OFBool DcmQueryRetrieveCharacterSetOptions::parseOptions(const char* mnemonic, char* valueptr)
{
    struct RAIIFree
    {
        RAIIFree(char* ptr) : ptr(ptr) {}
        ~RAIIFree() { free(ptr); }
        char* ptr;
    };
    if (strcmp(mnemonic, "SpecificCharacterSet") != 0)
        return OFFalse;
    characterSet.clear();
    flags = Configured;
    conversionFlags = 0;
    for (char* c = DcmConfigFile::parsevalues(&valueptr); c;
        c = DcmConfigFile::parsevalues(&valueptr)) {
        // ensure free is called when this scope is left
        RAIIFree cleanup(c);
        if (!strcmp(c, "override")) {
            flags |= Override;
        }
        else if (!strcmp(c, "fallback")) {
            flags |= Fallback;
        }
        else if (!strcmp(c, "abort")) {
            conversionFlags |= OFCharacterEncoding::AbortTranscodingOnIllegalSequence;
        }
        else if (!strcmp(c, "discard")) {
            conversionFlags |= OFCharacterEncoding::DiscardIllegalSequences;
        }
        else if (!strcmp(c, "transliterate")) {
            conversionFlags |= OFCharacterEncoding::TransliterateIllegalSequences;
        }
        else {
            characterSet = c;
        }
    }
    return OFTrue;
}

DcmConfigFile::~DcmConfigFile()
{
    // There can be more than one DcmConfigFilePeer which points to the
    // same strings. To make sure that we don't free them more than once, we use
    // a std::set<void*> which contains the pointers which we have to free.
    // This happens in DcmConfigFile::readPeerList() while handling
    // symbolic names (DcmConfigFilePeer gets copied via memcpy()).
    //
    // TODO: Since OFSet and std::set have nothing in common, we have to fake a
    // set via a map.
    OFMap<const void *, OFBool> pointersToFree;
    OFMap<const void *, OFBool>::const_iterator it;
    int i;

    for (i = 0; i < CNF_Config.noOfAEEntries; i++) {
        freeConfigAEEntry(pointersToFree, &CNF_Config.AEEntries[i]);
    }
    free(CNF_Config.AEEntries);

    for (i = 0; i < CNF_HETable.noOfHostEntries; i++) {
        freeConfigHostEntry(pointersToFree, &CNF_HETable.HostEntries[i]);
    }
    free(CNF_HETable.HostEntries);

    for (i = 0; i < CNF_VendorTable.noOfHostEntries; i++) {
        freeConfigHostEntry(pointersToFree, &CNF_VendorTable.HostEntries[i]);
    }
    free(CNF_VendorTable.HostEntries);

    for (it = pointersToFree.begin(); it != pointersToFree.end(); ++it) {
        free(OFconst_cast(void *, it->first));
    }
}

int DcmConfigFile::aeTitlesForPeer(const char *hostName, const char *** aeTitleList) const
{
    int n = 0;
    int i, j, k;
    const int chunkSize = 1;
    int maxAlloc = 0;
    const char *hname;
    const char *aetitle;
    int found;

    *aeTitleList = (const char**)malloc(chunkSize*sizeof(const char*));
    maxAlloc = chunkSize;

    /* collect up titles for peer, search in host table */
    for (i = 0; i < CNF_HETable.noOfHostEntries; i++) {
        for (j = 0; j < CNF_HETable.HostEntries[i].noOfPeers; j++) {
            hname = CNF_HETable.HostEntries[i].Peers[j].HostName;
            aetitle = CNF_HETable.HostEntries[i].Peers[j].ApplicationTitle;
#ifdef HAVE_PROTOTYPE_STRCASECMP
            if (strcasecmp(hname, hostName) == 0) {  /* DNS is not case-sensitive */
#elif defined(HAVE_PROTOTYPE__STRICMP)
            if (_stricmp(hname, hostName) == 0) {
#else
            if (strcmp(hname, hostName) == 0) {  /* fallback if case insensitive compare is unavailable */
#endif
                /* found an entry for peer host */
                /* make sure its not already in list */
                found = 0;
                for (k = 0; !found && k < n; k++) {
                    found = (strcmp((*aeTitleList)[k], aetitle) == 0);
                }
                if (!found) {
                    if (n >= maxAlloc) {
                        *aeTitleList = (const char**)realloc(*aeTitleList,
                            (maxAlloc + chunkSize)*sizeof(const char*));
                        maxAlloc += chunkSize;
                    }
                    (*aeTitleList)[n] = aetitle;

                    n++;
                }
            }
            }
            }
    /* collect up titles for peer, search in AE table */
    for (i = 0; i < CNF_Config.noOfAEEntries; i++) {
        for (j = 0; j < CNF_Config.AEEntries[i].noOfPeers; j++) {
            hname = CNF_Config.AEEntries[i].Peers[j].HostName;
            aetitle = CNF_Config.AEEntries[i].Peers[j].ApplicationTitle;

#ifdef HAVE_PROTOTYPE_STRCASECMP
            if (strcasecmp(hname, hostName) == 0) {  /* DNS is not case-sensitive */
#elif defined(HAVE_PROTOTYPE__STRICMP)
            if (_stricmp(hname, hostName) == 0) {
#else
            if (strcmp(hname, hostName) == 0) {  /* fallback if case insensitive compare is unavailable */
#endif
                /* found an entry for peer host */
                /* make sure its not already in list */
                found = 0;
                for (k = 0; !found && k < n; k++) {
                    found = (strcmp((*aeTitleList)[k], aetitle) == 0);
                }
                if (!found) {
                    if (n >= maxAlloc) {
                        *aeTitleList = (const char**)realloc(*aeTitleList,
                            (maxAlloc + chunkSize)*sizeof(const char*));
                        maxAlloc += chunkSize;
                    }
                    (*aeTitleList)[n] = aetitle;

                    n++;
                }
            }
            }
            }

    if (n == 0) {
        free(*aeTitleList);
        *aeTitleList = NULL;
    }
    return n;
        }


int DcmConfigFile::ctnTitles(const char *** ctnTitleList) const
{
    int i;
    int n = 0;

    n = CNF_Config.noOfAEEntries;
    *ctnTitleList = (const char**)malloc(n * sizeof(const char*));

    for (i = 0; i < n; i++) {
        (*ctnTitleList)[i] = CNF_Config.AEEntries[i].ApplicationTitle;
    }
    return n;
}


int DcmConfigFile::aeTitlesForSymbolicName(const char *symbolicName, const char *** aeTitleList) const
{
    int i = 0;
    int j = 0;
    int n = 0;

    for (i = 0; i < CNF_HETable.noOfHostEntries; i++) {
        if (strcmp(symbolicName, CNF_HETable.HostEntries[i].SymbolicName) == 0) {
            n = CNF_HETable.HostEntries[i].noOfPeers;
            *aeTitleList = (const char**)malloc(n * sizeof(const char*));
            for (j = 0; j < n; j++) {
                (*aeTitleList)[j] =
                    CNF_HETable.HostEntries[i].Peers[j].ApplicationTitle;
            }
            return n;
        }
    }
    return 0;

}

const char *DcmConfigFile::vendorForPeerAETitle(const char *peerAETitle) const
{
    int i = 0;
    int j = 0;

    for (i = 0; i < CNF_VendorTable.noOfHostEntries; i++) {
        for (j = 0; j < CNF_VendorTable.HostEntries[i].noOfPeers; j++) {
            if (strcmp(peerAETitle,
                CNF_VendorTable.HostEntries[i].Peers[j].ApplicationTitle) == 0) {
                return CNF_VendorTable.HostEntries[i].SymbolicName;
            }
        }
    }
    return NULL;
}

int DcmConfigFile::countCtnTitles() const
{
    return CNF_Config.noOfAEEntries;
}


void DcmConfigFile::initConfigStruct()
{
    m_username = "";
    m_GroupName = "";
    m_QueryRetrievePort = 104;
    maxPDUSize_ = 16384;
    maxAssociations_ = 16;
    CNF_Config.noOfAEEntries = 0;
    CNF_HETable.noOfHostEntries = 0;
    CNF_VendorTable.noOfHostEntries = 0;
}


void DcmConfigFile::panic(const char *fmt, ...)
{
    va_list  ap;
    va_start(ap, fmt);

#if defined(HAVE_VSNPRINTF) && defined(HAVE_PROTOTYPE_VSNPRINTF)
    char buf[4096];

#ifdef HAVE_PROTOTYPE_STD__VSNPRINTF
    std::vsnprintf(buf, sizeof(buf), fmt, ap);
#else
    vsnprintf(buf, sizeof(buf), fmt, ap);
#endif

    // Since we can't do anything about a too small buffer for vsnprintf(), we
    // ignore it. But we do make sure the buffer is null-terminated!
    buf[4095] = '\0';

    DCMQRDB_ERROR("CONFIG Error: " << buf << "!");
#else
    fprintf(stderr, "CONFIG Error: ");
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, "!\n");
#endif
    va_end(ap);
}


int DcmConfigFile::readConfigLines(FILE *cnffp)
{
    int  lineno = 0,       /* line counter */
        error = 0;        /* error flag */
    char rcline[512],      /* line in configuration file */
        mnemonic[512],    /* mnemonic in line */
        value[512],       /* parameter value */
        *valueptr;        /* pointer to value list */
    char *c;
    int store_dir_size = -1;
    int store_dir_index = 0;
    OFString store_index_name;
    // read all lines from configuration file
    while (fgets(rcline, sizeof(rcline), cnffp))
    {
        lineno++;
        if (rcline[0] == '#' || rcline[0] == 10 || rcline[0] == 13)
            continue;        /* comment or blank line */

        if (sscanf(rcline, "%s", mnemonic) != 1)
            continue;  /* ignore lines containing only whitespace */

        valueptr = skipmnemonic(rcline);

        if (!strcmp("ApplicationTitle", mnemonic))
        {
            // ignore this entry which was used (really?) in previous versions
        }
        else if (!strcmp("ApplicationContext", mnemonic))
        {
            // ignore this entry which was used (really?) in previous versions
        }
        else if (!strcmp("ImplementationClass", mnemonic))
        {
            // ignore this entry which was used (really?) in previous versions
        }
        else if (!strcmp("ImplementationVersion", mnemonic))
        {
            // ignore this entry which was used (really?) in previous versions
        }
        else if (!strcmp("NetworkType", mnemonic))
        {
            // ignore this entry which was used (really?) in previous versions
        }
        else if (!strcmp("UserName", mnemonic))
        {
            c = parsevalues(&valueptr);
            m_username = c;
            free(c);
        }
        //////////////////////////////////////////
        else if (!strcmp("sqlserver", mnemonic))
        {
            c = parsevalues(&valueptr);
            m_sqlserver = c;
            free(c);
        }
        else if (!strcmp("sqldbname", mnemonic))
        {
            c = parsevalues(&valueptr);
            m_sqldbname = c;
            free(c);
        }
        else if (!strcmp("sqlusername", mnemonic))
        {
            c = parsevalues(&valueptr);
            m_sqlusername = c;
            free(c);
        }
        else if (!strcmp("sqlpass", mnemonic))
        {
            c = parsevalues(&valueptr);
            m_sqlpass = c;
            free(c);
        }
        else if (!strcmp("store_dir_size", mnemonic))
        {
            c = parsevalues(&valueptr);
            store_dir_size = atoi(c);
            free(c);
            store_dir_index = 1;
            char index[3];
            store_index_name = itoa(store_dir_index, index, 10);
            store_index_name = "store_dir_" + store_index_name;

        }
        else if ((store_dir_size > 0) && (store_dir_index <= store_dir_size) && (!strcmp(store_index_name.c_str(), mnemonic)))
        {
            OFString dir;
            c = parsevalues(&valueptr);
            dir = c;
            free(c);
            m_storedir.push_back(dir);
            if (store_dir_index < store_dir_size)
            {
                store_dir_index++;
                char index[3];
                store_index_name = itoa(store_dir_index, index, 10);
                store_index_name = "store_dir_" + store_index_name;
            }
        }
        //store_dir_size
        //get m_storedir
        /////////////////////////////////////////
        else if (!strcmp("GroupName", mnemonic))
        {
            c = parsevalues(&valueptr);
            m_GroupName = c;
            free(c);
        }
        else if (!strcmp("NetworkTCPPort", mnemonic))
        {
            sscanf(valueptr, "%d", &m_QueryRetrievePort);
        }
        else if (!strcmp("QueryRetrievePort", mnemonic))
        {
            sscanf(valueptr, "%d", &m_QueryRetrievePort);
        }//
        else if (!strcmp("StoreScpPort", mnemonic))
        {
            sscanf(valueptr, "%d", &m_StoreScpPort);
        }
        else if (!strcmp("WorklistScpPort", mnemonic))
        {
            sscanf(valueptr, "%d", &m_WorklistScpPort);
        }//m_WorklistSingleProcess
        else if (!strcmp("WorklistSingleProcess", mnemonic))
        {
            sscanf(valueptr, "%d", &m_WorklistSingleProcess);
        }
        else if (!strcmp("MaxPDUSize", mnemonic))
        {
            unsigned long ul = 0;
            sscanf(valueptr, "%lu", &ul);
            maxPDUSize_ = OFstatic_cast(Uint32, ul);
        }
        else if (!strcmp("MaxAssociations", mnemonic))
        {
            sscanf(valueptr, "%d", &maxAssociations_);
        }
        else if (!strcmp("Display", mnemonic))
        {
            // ignore this entry which was needed for ctndisp
        }
        else if (!strcmp("DisplayPort", mnemonic))
        {
            // ignore this entry which was needed for ctndisp
        }
        else if (characterSetOptions_.parseOptions(mnemonic, valueptr))
        {
            // already handled by parseOptions(), nothing else to do
        }
        else if (!strcmp("HostTable", mnemonic))
        {
            sscanf(valueptr, "%s", value);
            if (!strcmp("BEGIN", value))
            {
                if (!readHostTable(cnffp, &lineno))
                    error = 1;
            }
            else if (!strcmp("END", value))
            {
                panic("No \"HostTable BEGIN\" before END in configuration file, line %d", lineno);
                error = 1;
            }
            else
            {
                panic("Unknown HostTable status \"%s\" in configuration file, line %d", value, lineno);
                error = 1;
            }
        }
        else if (!strcmp("VendorTable", mnemonic))
        {
            sscanf(valueptr, "%s", value);
            if (!strcmp("BEGIN", value))
            {
                if (!readVendorTable(cnffp, &lineno))
                    error = 1;
            }
            else if (!strcmp("END", value))
            {
                panic("No \"VendorTable BEGIN\" before END in configuration file, line %d", lineno);
                error = 1;
            }
            else
            {
                panic("Unknown VendorTable status \"%s\" in configuration file, line %d", value, lineno);
                error = 1;
            }
        }
        else if (!strcmp("AETable", mnemonic))
        {
            sscanf(valueptr, "%s", value);
            if (!strcmp("BEGIN", value))
            {
                if (!readAETable(cnffp, &lineno))
                    error = 1;
            }
            else if (!strcmp("END", value))
            {
                panic("No \"AETable BEGIN\" before END in configuration file, line %d", lineno);
                error = 1;
            }
            else
            {
                panic("Unknown AETable status \"%s\" in configuration file, line %d", value, lineno);
                error = 1;
            }
        }
        else
        {
            panic("Unknown mnemonic \"%s\" in configuration file, line %d", mnemonic, lineno);
            error = 1;
        }
    }

    return(error ? 0 : 1);
}


int DcmConfigFile::readHostTable(FILE *cnffp, int *lineno)
{
    int  error = 0,        /* error flag */
        end = 0,          /* end flag */
        noOfPeers;        /* number of peers for entry */
    char rcline[512],      /* line in configuration file */
        mnemonic[512],    /* mnemonic in line */
        value[512],       /* parameter value */
        *lineptr;         /* pointer to line */
    DcmConfigFileHostEntry *helpentry;

    // read certain lines from configuration file
    while (fgets(rcline, sizeof(rcline), cnffp))
    {
        (*lineno)++;
        if (rcline[0] == '#' || rcline[0] == 10 || rcline[0] == 13)
            continue;        /* comment or blank line */

        sscanf(rcline, "%s %s", mnemonic, value);
        if (!strcmp("HostTable", mnemonic))
        {
            if (!strcmp("END", value))
            {
                end = 1;
                break;
            }
            else
            {
                panic("Illegal HostTable status \"%s\" in configuration file, line %d", value, *lineno);
                error = 1;
                break;
            }
        }

        lineptr = rcline;
        CNF_HETable.noOfHostEntries++;
        if ((helpentry = (DcmConfigFileHostEntry *)malloc(CNF_HETable.noOfHostEntries * sizeof(DcmConfigFileHostEntry))) == NULL)
            panic("Memory allocation 1 (%d)", CNF_HETable.noOfHostEntries);
        if (CNF_HETable.noOfHostEntries - 1)
        {
            memcpy((char*)helpentry, (char*)CNF_HETable.HostEntries, (CNF_HETable.noOfHostEntries - 1) *sizeof(DcmConfigFileHostEntry));
            free(CNF_HETable.HostEntries);
        }
        CNF_HETable.HostEntries = helpentry;

        CNF_HETable.HostEntries[CNF_HETable.noOfHostEntries - 1].SymbolicName = parsevalues(&lineptr);
        CNF_HETable.HostEntries[CNF_HETable.noOfHostEntries - 1].Peers = readPeerList(&lineptr, &noOfPeers);
        CNF_HETable.HostEntries[CNF_HETable.noOfHostEntries - 1].noOfPeers = noOfPeers;
        if (!noOfPeers)
            error = 1;
    }

    if (!end)
    {
        error = 1;
        panic("No \"HostTable END\" in configuration file, line %d", *lineno);
    }
    return(error ? 0 : 1);
}


int DcmConfigFile::readVendorTable(FILE *cnffp, int *lineno)
{
    int  error = 0,        /* error flag */
        end = 0,          /* end flag */
        noOfPeers;        /* number of peers for entry */
    char rcline[512],      /* line in configuration file */
        mnemonic[512],     /* mnemonic in line */
        value[512],       /* parameter value */
        *lineptr;         /* pointer to line */
    DcmConfigFileHostEntry *helpentry;

    // read certain lines from configuration file
    while (fgets(rcline, sizeof(rcline), cnffp))
    {
        (*lineno)++;
        if (rcline[0] == '#' || rcline[0] == 10 || rcline[0] == 13)
            continue;        /* comment or blank line */

        sscanf(rcline, "%s %s", mnemonic, value);
        if (!strcmp("VendorTable", mnemonic))
        {
            if (!strcmp("END", value))
            {
                end = 1;
                break;
            }
            else
            {
                panic("Illegal VendorTable status \"%s\" in configuration file, line %d", value, *lineno);
                error = 1;
                break;
            }
        }

        lineptr = rcline;
        CNF_VendorTable.noOfHostEntries++;
        if ((helpentry = (DcmConfigFileHostEntry *)malloc(CNF_VendorTable.noOfHostEntries * sizeof(DcmConfigFileHostEntry))) == NULL)
            panic("Memory allocation 2 (%d)", CNF_VendorTable.noOfHostEntries);
        if (CNF_VendorTable.noOfHostEntries - 1) {
            memcpy((char*)helpentry, (char*)CNF_VendorTable.HostEntries, (CNF_VendorTable.noOfHostEntries - 1) *sizeof(DcmConfigFileHostEntry));
            free(CNF_VendorTable.HostEntries);
        }
        CNF_VendorTable.HostEntries = helpentry;

        CNF_VendorTable.HostEntries[CNF_VendorTable.noOfHostEntries - 1].SymbolicName = parsevalues(&lineptr);
        CNF_VendorTable.HostEntries[CNF_VendorTable.noOfHostEntries - 1].Peers = readPeerList(&lineptr, &noOfPeers);
        CNF_VendorTable.HostEntries[CNF_VendorTable.noOfHostEntries - 1].noOfPeers = noOfPeers;
        if (!noOfPeers)
            error = 1;
    }

    if (!end)
    {
        error = 1;
        panic("No \"VendorTable END\" in configuration file, line %d", *lineno);
    }
    return(error ? 0 : 1);
}


int DcmConfigFile::readAETable(FILE *cnffp, int *lineno)
{
    int  error = 0,          /* error flag */
        end = 0,            /* end flag */
        noOfAEEntries = 0;  /* number of AE entries */
    char rcline[512],        /* line in configuration file */
        mnemonic[512],      /* mnemonic in line */
        value[512],         /* parameter value */
        *lineptr;           /* pointer to line */
    DcmConfigFileAEEntry *helpentry;

    // read certain lines from configuration file
    while (fgets(rcline, sizeof(rcline), cnffp))
    {
        (*lineno)++;
        if (rcline[0] == '#' || rcline[0] == 10 || rcline[0] == 13)
            continue;        /* comment or blank line */

        sscanf(rcline, "%s %s", mnemonic, value);
        if (!strcmp("AETable", mnemonic))
        {
            if (!strcmp("END", value))
            {
                end = 1;
                break;
            }
            else
            {
                panic("Illegal AETable status \"%s\" in configuration file, line %d", value, *lineno);
                error = 1;
                break;
            }
        }

        lineptr = rcline;
        noOfAEEntries++;
        if ((helpentry = (DcmConfigFileAEEntry *)malloc(noOfAEEntries * sizeof(DcmConfigFileAEEntry))) == NULL)
            panic("Memory allocation 3 (%d)", noOfAEEntries);
        if (noOfAEEntries - 1) {
            memcpy((char*)helpentry, (char*)CNF_Config.AEEntries, (noOfAEEntries - 1) *sizeof(DcmConfigFileAEEntry));
            free(CNF_Config.AEEntries);
        }
        CNF_Config.AEEntries = helpentry;

        CNF_Config.AEEntries[noOfAEEntries - 1].ApplicationTitle = parsevalues(&lineptr);
        CNF_Config.AEEntries[noOfAEEntries - 1].StorageArea = parsevalues(&lineptr);
        CNF_Config.AEEntries[noOfAEEntries - 1].Access = parsevalues(&lineptr);
        CNF_Config.AEEntries[noOfAEEntries - 1].StorageQuota = parseQuota(&lineptr);
        if ((CNF_Config.AEEntries[noOfAEEntries - 1].StorageQuota->maxStudies == 0) ||
            (CNF_Config.AEEntries[noOfAEEntries - 1].StorageQuota->maxBytesPerStudy == 0))
            error = 1;
        else
        {
            CNF_Config.AEEntries[noOfAEEntries - 1].Peers = parsePeers(&lineptr, &CNF_Config.AEEntries[noOfAEEntries - 1].noOfPeers);
            if (!CNF_Config.AEEntries[noOfAEEntries - 1].noOfPeers) error = 1;
        }
    }

    if (!end)
    {
        error = 1;
        panic("No \"AETable END\" in configuration file, line %d", *lineno);
    }
    CNF_Config.noOfAEEntries = noOfAEEntries;
    return(error ? 0 : 1);
}


DcmConfigFileQuota *DcmConfigFile::parseQuota(char **valuehandle)
{
    int  studies;
    char *helpvalue,
        helpval[512];
    DcmConfigFileQuota *helpquota;

    if ((helpquota = (DcmConfigFileQuota *)malloc(sizeof(DcmConfigFileQuota))) == NULL)
        panic("Memory allocation 4");
    helpvalue = parsevalues(valuehandle);
    if (helpvalue)
    {
        sscanf(helpvalue, "%d , %s", &studies, helpval);
        helpquota->maxStudies = studies;
        helpquota->maxBytesPerStudy = quota(helpval);
    }
    else
    {
        helpquota->maxStudies = 0;
        helpquota->maxBytesPerStudy = 0;
    }
    free(helpvalue);

    return(helpquota);
}


DcmConfigFilePeer *DcmConfigFile::parsePeers(char **valuehandle, int *peers)
{
    char *helpvalue;
    char *valueptr = *valuehandle;

    helpvalue = parsevalues(valuehandle);
    if (!strcmp("ANY", helpvalue))
    {     /* keyword ANY used */
        free(helpvalue);
        *peers = -1;
        return((DcmConfigFilePeer *)0);
    }

    free(helpvalue);         /* regular peer list */
    return(readPeerList(&valueptr, peers));
}


DcmConfigFilePeer *DcmConfigFile::readPeerList(char **valuehandle, int *peers)
{
    int  i, found,noOfPeers = 0;
    char *helpvalue;
    DcmConfigFilePeer *helppeer,
        *peerlist = NULL;

    while ((helpvalue = parsevalues(valuehandle)) != NULL)
    {
        found = 0;
        if (strchr(helpvalue, ',') == NULL)
        {   /* symbolic name */
            if (!CNF_HETable.noOfHostEntries)
            {
                panic("No symbolic names defined");
                *peers = 0;
                free(helpvalue);
                return((DcmConfigFilePeer *)0);
            }
            for (i = 0; i < CNF_HETable.noOfHostEntries; i++)
            {
                if (!strcmp(CNF_HETable.HostEntries[i].SymbolicName, helpvalue))
                {
                    found = 1;
                    break;
                }
            }
            if (!found)
            {
                panic("Symbolic name \"%s\" not defined", helpvalue);
                *peers = 0;
                free(helpvalue);
                return((DcmConfigFilePeer *)0);
            }

            noOfPeers += CNF_HETable.HostEntries[i].noOfPeers;
            if ((helppeer = (DcmConfigFilePeer *)malloc(noOfPeers * sizeof(DcmConfigFilePeer))) == NULL)
                panic("Memory allocation 5 (%d)", noOfPeers);
            if (noOfPeers - CNF_HETable.HostEntries[i].noOfPeers) 
            {
                memcpy((char*)helppeer, (char*)peerlist, (noOfPeers - CNF_HETable.HostEntries[i].noOfPeers) * sizeof(DcmConfigFilePeer));
                free(peerlist);
            }
            peerlist = helppeer;
            memcpy((char*)(peerlist + (noOfPeers - CNF_HETable.HostEntries[i].noOfPeers)), (char*)CNF_HETable.HostEntries[i].Peers, CNF_HETable.HostEntries[i].noOfPeers * sizeof(DcmConfigFilePeer));
        }

        else
        {            /* peer */
            noOfPeers++;
            if ((helppeer = (DcmConfigFilePeer *)malloc(noOfPeers * sizeof(DcmConfigFilePeer))) == NULL)
                panic("Memory allocation 6 (%d)", noOfPeers);
            if (noOfPeers - 1)
            {
                memcpy((char*)helppeer, (char*)peerlist, (noOfPeers - 1) *sizeof(DcmConfigFilePeer));
                free(peerlist);
            }
            peerlist = helppeer;

            char *tempvalue = helpvalue;
            peerlist[noOfPeers - 1].ApplicationTitle = parsevalues(&helpvalue);
            peerlist[noOfPeers - 1].HostName = parsevalues(&helpvalue);
            peerlist[noOfPeers - 1].PortNumber = atoi(helpvalue);
            helpvalue = tempvalue;
        }
        free(helpvalue);
    }
    *peers = noOfPeers;
    return(peerlist);
}


char *DcmConfigFile::skipmnemonic(char *rcline)
{
    char *help = rcline;

    while (*help != '\0')
    {                       /* leading spaces */
        if (isgap(*help)) help++;
        else break;
    }
    while (*help != '\0')
    {
        if (!isspace(OFstatic_cast(unsigned char, *help))) help++;    /* Mnemonic */
        else break;
    }
    while (*help != '\0')
    {
        if (isgap(*help))
            help++;     /* Gap */
        else break;
    }
    return(help);
}


int DcmConfigFile::isgap(char gap)
{
    if (isspace(OFstatic_cast(unsigned char, gap)))
        return(1);
    if (gap == '=' || gap == ',' || gap == 10 || gap == 13)
        return(1);
    else
        return(0);
}


int DcmConfigFile::isquote(char quote)
{
    if (quote == '"' || quote == '\'' || quote == '(' || quote == ')')
        return(1);
    else
        return(0);
}


char *DcmConfigFile::parsevalues(char **valuehandle)
{
    int i, inquotes = 0, count = 0;
    char *value = NULL;
    const char *help,*valueptr = *valuehandle;

    if (isquote(*valueptr))
    {
        inquotes = 1;
        valueptr++;
    }

    help = valueptr;

    while (*help != '\0')
    {
        if (inquotes)
        {
            if (isquote(*help))
            {
                if ((value = (char*)malloc(count * sizeof(char) + 1)) == NULL)
                    panic("Memory allocation 7 (%d)", count);
                for (i = 0; i < count; i++)
                    value[i] = valueptr[i];
                value[count] = '\0';
                count++;
                help++;
                while (*help != '\0')
                {
                    if (isgap(*help))
                    {
                        count++;
                        help++;
                    }
                    else
                    {
                        break;
                    }
                }
                *valuehandle += (count + 1);
                break;
            }
            else
            {
                count++;
                help++;
            }
        }
        else
        {
            if (isgap(*help))
            {
                if ((value = (char*)malloc(count * sizeof(char) + 1)) == NULL)
                {
                    panic("Memory allocation 8 (%d)", count);
                }
                for (i = 0; i < count; i++)
                {
                    value[i] = valueptr[i];
                }
                value[count] = '\0';
                while (*help != '\0')
                {
                    if (isgap(*help))
                    {
                        count++;
                        help++;
                    }
                    else
                    {
                        break;
                    }
                }
                *valuehandle += count;
                break;
            }
            else
            {
                count++;
                help++;
            }
        } /* inquotes */
    } /* while */

    return(value);
}


long DcmConfigFile::quota(const char *value)
{
    int  number;
    long factor;
    char last = *(value + strlen(value) - 1),  /* last character */
        mult = *(value + strlen(value) - 2);       /* multiplier */

    if (last == 'b' || last == 'B')
    {
        if (mult == 'k' || mult == 'K')
            factor = 1024;
        else if (mult == 'm' || mult == 'M')
            factor = 1024 * 1024;
        else if (mult == 'g' || mult == 'G')
            factor = 1024 * 1024 * 1024;
        else
            factor = 1;
    }
    else return(-1L);

    number = atoi(value);
    return(number * factor);
}


int DcmConfigFile::init(const char *ConfigurationFile)
{
    int  error = 0;        /* error flag */
    FILE *cnffp;         /* configuration file pointer */

    if ((cnffp = fopen(ConfigurationFile, "r")) == NULL) {
        panic("Unable to open configuration file \"%s\"", ConfigurationFile);
        return(0);
    }

    initConfigStruct();

    if (!readConfigLines(cnffp)) {
        panic("Reading configuration file \"%s\" with errors", ConfigurationFile);
        error = 1;
    }

    fclose(cnffp);

    return(error ? 0 : 1);
}


void DcmConfigFile::printConfig()
{
    int i, j;

    DCMQRDB_INFO("\nHostTable: " << CNF_HETable.noOfHostEntries);
    for (i = 0; i < CNF_HETable.noOfHostEntries; i++)
    {
        DCMQRDB_INFO(CNF_HETable.HostEntries[i].SymbolicName << " " << CNF_HETable.HostEntries[i].noOfPeers);
        for (j = 0; j < CNF_HETable.HostEntries[i].noOfPeers; j++)
        {
            DCMQRDB_INFO(CNF_HETable.HostEntries[i].Peers[j].ApplicationTitle << " " <<
                CNF_HETable.HostEntries[i].Peers[j].HostName << " " << CNF_HETable.HostEntries[i].Peers[j].PortNumber);
        }
    }
    DCMQRDB_INFO("\nVendorTable: " << CNF_VendorTable.noOfHostEntries);
    for (i = 0; i < CNF_VendorTable.noOfHostEntries; i++)
    {
        DCMQRDB_INFO(CNF_VendorTable.HostEntries[i].SymbolicName << " " << CNF_VendorTable.HostEntries[i].noOfPeers);
        for (j = 0; j < CNF_VendorTable.HostEntries[i].noOfPeers; j++)
        {
            DCMQRDB_INFO(CNF_VendorTable.HostEntries[i].Peers[j].ApplicationTitle << " " <<
                CNF_VendorTable.HostEntries[i].Peers[j].HostName << " " << CNF_VendorTable.HostEntries[i].Peers[j].PortNumber);
        }
    }
    DCMQRDB_INFO("\nGlobal Parameters:\n" << m_QueryRetrievePort << "\n" << OFstatic_cast(unsigned long, maxPDUSize_)
        << "\n" << maxAssociations_);
    DCMQRDB_INFO("\nAEEntries: " << CNF_Config.noOfAEEntries);
    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        DCMQRDB_INFO(CNF_Config.AEEntries[i].ApplicationTitle << "\n" << CNF_Config.AEEntries[i].StorageArea
            << "\n" << CNF_Config.AEEntries[i].Access << "\n" << CNF_Config.AEEntries[i].StorageQuota->maxStudies
            << ", " << CNF_Config.AEEntries[i].StorageQuota->maxBytesPerStudy);
        if (CNF_Config.AEEntries[i].noOfPeers == -1)
        {
            DCMQRDB_INFO("Peers: ANY");
        }
        else
        {
            DCMQRDB_INFO("Peers: " << CNF_Config.AEEntries[i].noOfPeers);
            for (j = 0; j < CNF_Config.AEEntries[i].noOfPeers; j++)
            {
                DCMQRDB_INFO(CNF_Config.AEEntries[i].Peers[j].ApplicationTitle << " " <<
                    CNF_Config.AEEntries[i].Peers[j].HostName << " " << CNF_Config.AEEntries[i].Peers[j].PortNumber);
            }
        }
        DCMQRDB_INFO("----------------------------------\n");
    }
}


int DcmConfigFile::getNetworkTCPPort() const
{
    return(m_QueryRetrievePort);
}

int DcmConfigFile::getQueryRetrievePort() const
{
    return(m_QueryRetrievePort);
}

int DcmConfigFile::getWorklistScpPort() const
{
    return(m_WorklistScpPort);
}
int DcmConfigFile::getStoreScpPort() const
{
    return(m_StoreScpPort);
}

int DcmConfigFile::getWorklistSingleProcess() const
{
    return(m_WorklistSingleProcess);
}
OFCmdUnsignedInt DcmConfigFile::getMaxPDUSize() const
{
    return(maxPDUSize_);
}


int DcmConfigFile::getMaxAssociations() const
{
    return(maxAssociations_);
}


const char *DcmConfigFile::getStorageArea(const char *AETitle) const
{
    int  i;

    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        if (!strcmp(AETitle, CNF_Config.AEEntries[i].ApplicationTitle))
        {
            return(CNF_Config.AEEntries[i].StorageArea);
        }
    }
    return(NULL);        /* AETitle not found */
}


const char *DcmConfigFile::getAccess(const char *AETitle) const
{
    int  i;

    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        if (!strcmp(AETitle, CNF_Config.AEEntries[i].ApplicationTitle))
        {
            return(CNF_Config.AEEntries[i].Access);
        }
    }
    return(NULL);        /* AETitle not found */
}


int DcmConfigFile::getMaxStudies(const char *AETitle) const
{
    int  i;

    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        if (!strcmp(AETitle, CNF_Config.AEEntries[i].ApplicationTitle))
        {
            return(CNF_Config.AEEntries[i].StorageQuota->maxStudies);
        }
    }
    return(0);       /* AETitle not found */
}

long DcmConfigFile::getMaxBytesPerStudy(const char *AETitle) const
{
    int  i;

    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        if (!strcmp(AETitle, CNF_Config.AEEntries[i].ApplicationTitle))
        {
            return(CNF_Config.AEEntries[i].StorageQuota->maxBytesPerStudy);
        }
    }
    return(0);       /* AETitle not found */
}


int DcmConfigFile::peerInAETitle(const char *calledAETitle, const char *callingAETitle, const char *HostName) const
{
    int  i, j;
    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        if (!strcmp(calledAETitle, CNF_Config.AEEntries[i].ApplicationTitle))
        {
            if (CNF_Config.AEEntries[i].noOfPeers == -1) /* ANY Peer allowed */
                return(1);
            for (j = 0; j < CNF_Config.AEEntries[i].noOfPeers; j++)
            {
                if (!strcmp(callingAETitle, CNF_Config.AEEntries[i].Peers[j].ApplicationTitle) &&
#ifdef HAVE_PROTOTYPE_STRCASECMP
                    /* DNS is not case-sensitive */
                    !strcasecmp(HostName, CNF_Config.AEEntries[i].Peers[j].HostName))
#elif defined(HAVE_PROTOTYPE__STRICMP)
                    !_stricmp(HostName, CNF_Config.AEEntries[i].Peers[j].HostName))
#else
                    /* fallback solution is to do case sensitive comparison on systems
                    which do not implement strcasecmp or _stricmp */
                    !strcmp(HostName, CNF_Config.AEEntries[i].Peers[j].HostName))
#endif
                    return(1);       /* Peer found */
            }
        }
    }
    return(0);           /* Peer not found */
}


int DcmConfigFile::peerForAETitle(const char *AETitle, const char **HostName, int *PortNumber) const
{
    int  i, j;

    for (i = 0; i < CNF_Config.noOfAEEntries; i++)
    {
        for (j = 0; j < CNF_Config.AEEntries[i].noOfPeers; j++)
        {
            if (!strcmp(AETitle, CNF_Config.AEEntries[i].Peers[j].ApplicationTitle))
            {
                *HostName = CNF_Config.AEEntries[i].Peers[j].HostName;
                *PortNumber = CNF_Config.AEEntries[i].Peers[j].PortNumber;
                return(1);        /* Peer found in AETable */
            }
        }
    }

    for (i = 0; i < CNF_HETable.noOfHostEntries; i++)
    {
        for (j = 0; j < CNF_HETable.HostEntries[i].noOfPeers; j++)
        {
            if (!strcmp(AETitle, CNF_HETable.HostEntries[i].Peers[j].ApplicationTitle))
            {
                *HostName = CNF_HETable.HostEntries[i].Peers[j].HostName;
                *PortNumber = CNF_HETable.HostEntries[i].Peers[j].PortNumber;
                return(2);        /* Peer found in HostTable */
            }
        }
    }

    return(0);         /* Peer not found */
}


int DcmConfigFile::checkForSameVendor(const char *AETitle1, const char *AETitle2) const
{
    int  i, j, k, found = 0;

    for (i = 0; i < CNF_VendorTable.noOfHostEntries; i++)
    {
        for (j = 0; j < CNF_VendorTable.HostEntries[i].noOfPeers; j++)
        {
            if (!strcmp(AETitle1, CNF_VendorTable.HostEntries[i].Peers[j].ApplicationTitle))
            {
                for (k = 0; k < CNF_VendorTable.HostEntries[i].noOfPeers; k++)
                {
                    if (!strcmp(AETitle2, CNF_VendorTable.HostEntries[i].Peers[k].ApplicationTitle))
                    {
                        found = 1;
                    }
                }
            }
        }
    }

    return(found);
}


int DcmConfigFile::HostNamesForVendor(const char *Vendor, const char ***HostNameArray) const
{
    int  i, j, found = 0;

    for (i = 0; i < CNF_VendorTable.noOfHostEntries; i++)
    {
        if (!strcmp(CNF_VendorTable.HostEntries[i].SymbolicName, Vendor))
        {
            found = 1;
            break;
        }
    }

    if (!found)
    {
        return(0);
    }


    if ((*HostNameArray = (const char**)malloc(CNF_VendorTable.HostEntries[i].noOfPeers * sizeof(const char *))) == NULL)
    {
        panic("Memory allocation A (%d)", CNF_VendorTable.HostEntries[i].noOfPeers);
        return(0);
    }
    for (j = 0; j < CNF_VendorTable.HostEntries[i].noOfPeers; j++)
    {
        (*HostNameArray)[j] = CNF_VendorTable.HostEntries[i].Peers[j].HostName;
    }

    return(CNF_VendorTable.HostEntries[i].noOfPeers);
}

OFBool DcmConfigFile::writableStorageArea(const char *aeTitle) const
{
    const char *axs = getAccess((char*)aeTitle);
    if (axs != NULL)
    {
        if (strcmp(axs, "RW") == 0)
            return OFTrue;
        if (strcmp(axs, "WR") == 0)
            return OFTrue;
        if (strcmp(axs, "W") == 0)
            return OFTrue;
    }

    return OFFalse;
}

const char *DcmConfigFile::getUserName() const
{
    return m_username.c_str();
}

const char *DcmConfigFile::getGroupName() const
{
    return m_GroupName.c_str();
}

const DcmQueryRetrieveCharacterSetOptions& DcmConfigFile::getCharacterSetOptions() const
{
    return characterSetOptions_;
}

DcmQueryRetrieveCharacterSetOptions& DcmConfigFile::getCharacterSetOptions()
{
    return characterSetOptions_;
}

const char *DcmConfigFile::getSqlServer() const
{
    return m_sqlserver.c_str();
}
const char *DcmConfigFile::getSqldbname() const
{
    return m_sqldbname.c_str();
}
const char *DcmConfigFile::getSqlusername() const
{
    return m_sqlusername.c_str();
}
const char *DcmConfigFile::getSqlpass() const
{
    return m_sqlpass.c_str();

}
