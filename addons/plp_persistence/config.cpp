class CfgPatches
{
    class plp_persistence
    {
        name = "PLP Persistence";
        author = "Codex";
        version = 0.205;
        versionStr = "0.2.5";
        versionAr[] = {0, 2, 5};
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F", "cba_main", "cba_settings", "cba_xeh"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions
{
    class PLP
    {
        class persistence
        {
            file = "\plp_persistence\functions";
            class applyPlayerData {};
            class clearMissionData {};
            class applyCargoData {};
            class collectCargoData {};
            class collectLogisticsData {};
            class collectPlayerData {};
            class deleteObjectAndSave {};
            class ensureServerState {};
            class flushPlayerData {};
            class getDefaultObjectId {};
            class getObjectCategory {};
            class handleServerSaveAndExit {};
            class init { postInit = 1; };
            class isAdminClient {};
            class isLogisticsPersistent {};
            class log {};
            class loadLogistics {};
            class normalizeLogisticsRecord {};
            class normalizePlayerData {};
            class registerAceActions {};
            class registerLogisticsObject {};
            class requestPlayerLoad {};
            class reapplyLogisticsCargo {};
            class saveAndExit {};
            class saveAndExitComplete {};
            class saveAll {};
            class serverSaveAndExit {};
            class storePlayerData {};
            class upsertLogisticsData {};
            class validateLogisticsRecord {};
            class validatePlayerData {};
        };
    };
};

class Extended_PreInit_EventHandlers
{
    class plp_persistence
    {
        init = "call compile preprocessFileLineNumbers '\plp_persistence\XEH_preInit.sqf'";
    };
};
