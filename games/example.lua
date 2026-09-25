-- Development-only UI example. No gameplay actions or presence reporting.
local BASE="https://raw.githubusercontent.com/MUshihara/SerenityHubv2/main/"
local UI=loadstring(game:HttpGet(BASE.."dist/ui/universal-v3-2-0.lua"))()
local manifest={
    SerenityAPIVersion=3, GameName="New Game Example",
    RuntimeKey="__SERENITY_V2_EXAMPLE",
    ConfigPath="SerenityHub/dev-example.json",ConfigVersion=1,
    Pages={{Id="Example",Title="Example",Icon="settings",Features={
        {Id="Controls",Title="Getting started",Controls={
            {Id="Info",Type="Paragraph",Title="Development example",Text="Replace these controls with your tested game features."},
            {Id="Enabled",Type="Switch",Title="Example toggle",Default=false,
                Changed=function(value,window) window:Notify("Example",value and "Enabled" or "Disabled") end},
            {Id="Test",Type="Action",Title="Test notification",
                Callback=function(window) window:Notify("Example","The library is connected.") end}
        }}
    }}}
}
return UI.Build(manifest,{RuntimeKey=manifest.RuntimeKey,ConfigPath=manifest.ConfigPath})
