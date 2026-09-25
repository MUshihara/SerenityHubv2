-- Development-only UI example. No gameplay actions or presence reporting.
local BASE="https://raw.githubusercontent.com/MUshihara/SerenityHubv2/main/"
local UI=loadstring(game:HttpGet(BASE.."dist/ui/universal-v3-2-0.lua"))()
local manifest={
    SerenityAPIVersion=3, GameName="Trips Example",
    RuntimeKey="__SERENITY_V2_TRIPS_EXAMPLE",
    ConfigPath="SerenityHub/trips-example.json",ConfigVersion=1,
    Pages={{Id="TripsPage",Title="Trips Example",Icon="settings",Features={
        {Id="Controls",Title="Getting started",Controls={
            {Id="Info",Type="Paragraph",Title="Trips Example",Text="Test script for Trips Example integration with Serenity Hub."},
            {Id="Enabled",Type="Switch",Title="Trips toggle",Default=false,
                Changed=function(value,window) window:Notify("Trips Example",value and "Enabled" or "Disabled") end},
            {Id="Test",Type="Action",Title="Test notification",
                Callback=function(window) window:Notify("Trips Example","Trips Example is successfully connected.") end}
        }}
    }}}
}
return UI.Build(manifest,{RuntimeKey=manifest.RuntimeKey,ConfigPath=manifest.ConfigPath})
