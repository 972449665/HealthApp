#ifndef __tonoka_sendStatus__
#define __tonoka_sendStatus__

/**
@file
Subclass of sendStatus, which is generated by wxFormBuilder.
*/

#include "gui.h"

//// end generated include

#include "dicomsender.h"
#include <wx/timer.h>

/** Implementing sendStatus */
class tonoka_sendStatus : public sendStatus
{
	protected:
		// Handlers for sendStatus events.
		void OnStop( wxCommandEvent& event );
	public:
		/** Constructor */
		tonoka_sendStatus( wxWindow* parent );
	//// end generated class members

		~tonoka_sendStatus();
		wxTimer timer;
		void OnTimer(wxTimerEvent& event);
		DICOMSender *m_sender;

};

#endif // __tonoka_sendStatus__
