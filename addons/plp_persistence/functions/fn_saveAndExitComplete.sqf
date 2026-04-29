/*
    Exits the local client after server save acknowledgement.
*/
if (!hasInterface) exitWith {};

systemChat "PLP: Server save complete. Exiting mission...";

[] spawn {
    sleep 1;
    endMission "END1";
};

