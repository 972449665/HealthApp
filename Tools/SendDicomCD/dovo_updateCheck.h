#ifndef __dovo_updateCheck__
#define __dovo_updateCheck__

/**
@file
Subclass of updateCheck, which is generated by wxFormBuilder.
*/

#include "gui.h"

//// end generated include

/** Implementing updateCheck */
class dovo_updateCheck : public updateCheck
{
    protected:
        // Handlers for updateCheck events.
        void updateCheckOnInitDialog( wxInitDialogEvent& event );
    public:
        /** Constructor */
        dovo_updateCheck( wxWindow* parent );
    //// end generated class members
        
        wxString m_updatetext, m_version, m_message;

};

#endif // __dovo_updateCheck__
