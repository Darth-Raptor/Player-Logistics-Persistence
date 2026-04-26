class CfgPatches
{
    class plp_persistence
    {
        name = "PLP Persistence";
        author = "Codex";
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
            class getDefaultObjectId {};
            class isCategoryEnabled {};
            class getObjectCategory {};
            class init { postInit = 1; };
            class isLogisticsPersistent {};
            class log {};
            class loadLogistics {};
            class registerLogisticsObject {};
            class requestPlayerLoad {};
            class saveAll {};
            class storePlayerData {};
            class upsertLogisticsData {};
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
