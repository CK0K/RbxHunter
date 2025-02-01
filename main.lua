-- RBXHunter Client-Side Scanner
-- Autor: [Teu Nome]
-- Objetivo: Analisar vulnerabilidades client-side no jogo

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

print("🔍 [RBXHunter] Iniciando scanner client-side...")

-- Função para listar RemoteEvents e RemoteFunctions acessíveis pelo jogador
local function scanRemotes()
    print("\n📡 [Scanner] Analisando RemoteEvents e RemoteFunctions...")
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("⚠️ Encontrado:", obj.ClassName, obj.Name, "em", obj.Parent:GetFullName())
            
            -- Testa enviar um pacote de dados para RemoteEvent (pode falhar se o servidor tiver segurança)
            if obj:IsA("RemoteEvent") then
                pcall(function()
                    obj:FireServer("TESTE_RBXHUNTER")
                    print("✅ [Teste] Pacote enviado para:", obj.Name)
                end)
            elseif obj:IsA("RemoteFunction") then
                pcall(function()
                    local response = obj:InvokeServer("TESTE_RBXHUNTER")
                    print("✅ [Teste] Resposta recebida de:", obj.Name, "->", response)
                end)
            end
        end
    end
end

-- Função para analisar permissões inseguras em objetos
local function scanInsecureObjects()
    print("\n🔍 [Scanner] Verificando objetos locais...")
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.CanCollide == false and obj.Transparency < 0.5 then
            print("⚠️ [Alerta] Objeto invisível detectado:", obj.Name, "em", obj.Parent:GetFullName())
        end
    end
end

-- Executa o scanner
scanRemotes()
scanInsecureObjects()
print("\n✅ [RBXHunter] Scanner concluído!")
