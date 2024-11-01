local placeId = game.PlaceId
local allowedPlaceId = 18768679013 -- ID do lugar

if placeId ~= allowedPlaceId then
    print("Esta interface só funciona no jogo específico.")
    return -- Não faz nada se o jogo não for o permitido
end

-- Carrega as bibliotecas necessárias
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Cria a janela principal
local Window = Fluent:CreateWindow({
    Title = "Every Click +1 Speed ♥️ By Zetra Hub First Version",
    SubTitle = "",
    TabWidth = 135,
    Size = UDim2.fromOffset(440, 352),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Adiciona abas à janela
local Tabs = {
    InfoScript = Window:AddTab({ Title = " 📜 Info Script" }),
    AutoFarm = Window:AddTab({ Title = " ⭐ Auto Farm" }),
    Misc = Window:AddTab({ Title = " ⭐ Misc" }),
    Settings = Window:AddTab({ Title = " ⚙️ UI Settings" }),
}
local Options = Fluent.Options

-- Notifica o usuário
Fluent:Notify({
    Title = "By ZetraScripts YT",
    Content = "Thanks for using the script",
    SubContent = "",
    Duration = 5
})
-- Aba Info Script

local SupportSection = Tabs.InfoScript:AddSection("Support")

Tabs.InfoScript:AddParagraph({
    Title = "Supported",
    Content = "- Mobile\n- PC\n- Emulator\n- Console"
})

local UpdatesSection = Tabs.InfoScript:AddSection("Updates")

Tabs.InfoScript:AddParagraph({
    Title = "Updates",
    Content = "- 31/10/2024"
})

local YoutubeSection = Tabs.InfoScript:AddSection("Youtube")

Tabs.InfoScript:AddParagraph({
    Title = "Credits Script",
    Content = "- YouTube ZetraScripts"
})

local linkParaCopiar = "https://youtube.com/@zetrascripts?si=suM_heCy4O_X-P4H"

Tabs.InfoScript:AddButton({
    Title = "Youtube Channel",
    Description = "copy the link and paste into your browser",
    Callback = function()
        setclipboard(linkParaCopiar)
        print("Link copied to clipboard.")
    end
})

-- Anti Afk

local AntiAFKEnabled = true

local Toggle = Tabs.Misc:AddToggle("MyToggle", {Title = "Anti AFK", Default = true})

Toggle:OnChanged(function()
    AntiAFKEnabled = Options.MyToggle.Value
    print("Toggle changed:", AntiAFKEnabled)
end)

Options.MyToggle:SetValue(true)

Tabs.Misc:AddButton({
    Title = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local placeId = game.PlaceId

        local function serverHop()
            local servers
            local cursor = ""

            -- Tentar obter uma lista de servidores
            local success, response = pcall(function()
                local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor
                return HttpService:JSONDecode(game:HttpGet(url))
            end)

            if success and response and response.data then
                servers = response.data
            else
                warn("NÃ£o foi possÃ­vel obter servidores.")
                return
            end

            -- Encontrar um servidor diferente do atual
            for _, server in ipairs(servers) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    -- Teleportar para o servidor encontrado
                    TeleportService:TeleportToPlaceInstance(placeId, server.id)
                    return
                end
            end

            -- Caso nÃ£o encontre um servidor, tentar buscar mais servidores com cursor
            if response.nextPageCursor then
                cursor = response.nextPageCursor
                serverHop() -- Tenta novamente com o prÃ³ximo cursor
            else
                warn("Nenhum servidor disponÃ­vel para hop.")
            end
        end

        -- Chamar a funÃ§Ã£o de server hop
        serverHop()
    end
})

Tabs.Misc:AddButton({
    Title = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer

        -- Teleporta o jogador para o mesmo jogo
        TeleportService:Teleport(game.PlaceId, player)
    end
})

-- Auto Farm Wins

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define um deslocamento vertical
local offset = 10

-- Variável para controlar o estado do toggle
local isTeleporting = false

-- Variável para armazenar a posição de destino
local currentDestination = nil

-- Cria o dropdown na aba Auto Farm
local Dropdown = Tabs.AutoFarm:AddDropdown("Dropdown", {
    Title = "Select WINS",
    Values = {
        "Auto Farm 1 WINS",    -- 580, 414, 11797
        "Auto Farm 2 WINS",    -- 1605, 0, 10891
        "Auto Farm 3 WINS",    -- 2503, 4, 9030
        "Auto Farm 5 WINS",    -- 3649, 9, 10752
        "Auto Farm 7 WINS",    -- 4671, 3, 11247
        "Auto Farm 15 WINS",   -- 5573, 4, 8033
        "Auto Farm 30 WINS",   -- 6722, 4, 5302
        "Auto Farm 50 WINS",   -- 7545, 3, 3176
        "Auto Farm 100 WINS",  -- 8770, 4, 15301
        "Auto Farm 160 WINS",  -- 9794, 5, 16354
        "Auto Farm 230 WINS",  -- 10695, 3, 24523
        "Auto Farm 315 WINS",  -- 11719, 4, 26571 (novo)
        "Auto Farm 450 WINS",  -- 12866, 4, 30666 (novo)
        "Auto Farm 550 WINS"   -- 13890, 6, -18551 (novo)
    },
    Multi = false,
    Default = 1,
})

-- Tabela de coordenadas correspondentes
local coordinatesMap = {
    ["Auto Farm 1 WINS"] = Vector3.new(580, 414, 11797),
    ["Auto Farm 2 WINS"] = Vector3.new(1605, 0, 10891),
    ["Auto Farm 3 WINS"] = Vector3.new(2503, 4, 9030),
    ["Auto Farm 5 WINS"] = Vector3.new(3649, 9, 10752),
    ["Auto Farm 7 WINS"] = Vector3.new(4671, 3, 11247),
    ["Auto Farm 15 WINS"] = Vector3.new(5573, 4, 8033),
    ["Auto Farm 30 WINS"] = Vector3.new(6722, 4, 5302),
    ["Auto Farm 50 WINS"] = Vector3.new(7545, 3, 3176),
    ["Auto Farm 100 WINS"] = Vector3.new(8770, 4, 15301),
    ["Auto Farm 160 WINS"] = Vector3.new(9794, 5, 16354),
    ["Auto Farm 230 WINS"] = Vector3.new(10695, 3, 24523),
    ["Auto Farm 315 WINS"] = Vector3.new(11719, 4, 26571),    -- Coordenadas para Auto Farm 315 WINS
    ["Auto Farm 450 WINS"] = Vector3.new(12866, 4, 30666),    -- Coordenadas para Auto Farm 450 WINS
    ["Auto Farm 550 WINS"] = Vector3.new(13890, 6, -18551)    -- Coordenadas para Auto Farm 550 WINS
}

-- Função para teleportar
local function teleport(destination)
    character:SetPrimaryPartCFrame(CFrame.new(destination))
end

-- Cria o toggle na aba Auto Farm com o título "Auto Farm"
local Toggle = Tabs.AutoFarm:AddToggle("MyToggle", {Title = "Auto Farm", Default = false })

Toggle:OnChanged(function()
    isTeleporting = Toggle.Value  -- Atualiza o estado do teleporting com base no toggle
    print("Toggle changed:", isTeleporting)

    -- Se o toggle estiver ativado, teleportar para a posição atual
    if isTeleporting and currentDestination then
        teleport(currentDestination + Vector3.new(0, offset, 0))  -- Adiciona deslocamento vertical
        while isTeleporting do
            wait(1)
            teleport(currentDestination + Vector3.new(0, offset, 0))  -- Teleporta a cada segundo
        end
    end
end)

-- Monitora mudanças no dropdown
Dropdown:OnChanged(function(value)
    currentDestination = coordinatesMap[value]  -- Atualiza a posição de destino com base na seleção
    print("Selected destination:", value)

    -- Se o toggle estiver ativo, reinicia o teleport
    if isTeleporting and currentDestination then
        teleport(currentDestination + Vector3.new(0, offset, 0))  -- Adiciona deslocamento vertical
    end
end)

Dropdown:SetValue("Auto Farm 1 WINS")  -- Define o valor inicial do dropdown
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()