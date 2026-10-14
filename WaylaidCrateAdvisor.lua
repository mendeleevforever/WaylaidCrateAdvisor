-- WaylaidCrateAdvisor.lua
-- Shows the cheapest single fill option per Waylaid Crate using Auctionator prices

local ADDON_NAME = "WaylaidCrateAdvisor"
local WCA = {}
_G[ADDON_NAME] = WCA

-- ============================================================
-- ITEM IDs  (sourced from foreverdiff.com)
-- ============================================================
local ID = {
    StrangeDust=10940, GreaterMagicEssence=10939, SmallGlimmeringShard=10978, LargeGlimmeringShard=11084,
    SoulDust=11083, GreaterAstralEssence=11082, SmallGlowingShard=11138, LargeGlowingShard=11139,
    VisionDust=11137, GreaterMysticEssence=11135, SmallRadiantShard=11177, LargeRadiantShard=11178,
    DreamDust=11176, GreaterNetherEssence=11175, SmallBrilliantShard=14343, LargeBrilliantShard=14344,
    Peacebloom=2447, Silverleaf=765, Earthroot=2449, Mageroyal=785, Briarthorn=2450,
    Stranglekelp=3820, Bruiseweed=2453, WildSteelbloom=3355, GraveMoss=3369, Kingsblood=3356,
    Liferoot=3357, Fadeleaf=3818, Goldthorn=3821, KhadgarsWhisker=3358,
    Wintersbite=3819, Firebloom=4625, PurpleLotus=8831, ArthasTears=8836,
    GoldenSansam=13464, Sungrass=8838, Blindweed=8839, GhostMushroom=8845, Gromsblood=8846,
    Dreamfoil=13463, MountainSilversage=13465, Plaguebloom=13466, Icecap=13467,
    CopperOre=2770, TinOre=2771, SilverOre=2775, IronOre=2772, GoldOre=2776,
    MithrilOre=3858, TruesilverOre=7911, ThoriumOre=10620,
    LinenCloth=2589, LightLeather=2318, WoolCloth=2592, SilkCloth=4306, MediumLeather=2319,
    MageweaveCloth=4338, HeavyLeather=4234, Runecloth=14047, ThickLeather=4304, RuggedLeather=8170,
    HandfulOfCopperBolts=4359, CopperTube=4361, CopperModulator=4363,
    BronzeTube=4371, WhirringBronzeGizmo=4375, BronzeFramework=4382, GoldPowerCore=10558,
    IronStrut=4387, MithrilTube=10559, UnstableTrigger=10560, MithrilCasing=10561,
    ThoriumWidget=15994, TruesilverTransformer=18631, ThoriumTube=16000,
    CuredLightHide=4231, BoltOfLinenCloth=2996, BoltOfWoolenCloth=2997, BoltOfSilkCloth=4305,
    CuredMediumHide=4233, BoltOfMageweave=4339, CuredHeavyHide=4236, BoltOfRunecloth=14048, CuredThickHide=8172,
    CopperBar=2840, TinBar=3576, BronzeBar=2841, SilverBar=2842, IronBar=3575, GoldBar=3577,
    MithrilBar=3860, SteelBar=3859, TruesilverBar=6037, ThoriumBar=12359, DarkIronBar=11371,
}

-- ============================================================
-- CRATE DEFINITIONS
-- items = list of { itemID, qty } — player picks ONE to fill the crate
-- Crate AH sell price is looked up live from Auctionator (same as fill items)
-- ============================================================
WCA.CRATES = {
    -- ── APPRENTICE ───────────────────────────────────────────
    [248685]={name="Waylaid Crate: Apprentice Curiosities", tier="Apprentice", subtier="Curiosities",
        items={{ID.StrangeDust,20},{ID.GreaterMagicEssence,4},{ID.SmallGlimmeringShard,6},{ID.LargeGlimmeringShard,2}}},
    [248682]={name="Waylaid Crate: Apprentice Herbs",       tier="Apprentice", subtier="Herbs",
        items={{ID.Peacebloom,20},{ID.Silverleaf,20},{ID.Earthroot,10},{ID.Mageroyal,10},{ID.Briarthorn,10}}},
    [248683]={name="Waylaid Crate: Apprentice Ore",         tier="Apprentice", subtier="Ore",
        items={{ID.CopperOre,20},{ID.TinOre,20}}},
    [248684]={name="Waylaid Crate: Apprentice Textiles",    tier="Apprentice", subtier="Textiles",
        items={{ID.LinenCloth,40},{ID.LightLeather,20}}},
    [248704]={name="Waylaid Crate: Apprentice Parts",       tier="Apprentice", subtier="Parts",
        items={{ID.HandfulOfCopperBolts,16},{ID.CopperTube,16},{ID.CopperModulator,4}}},
    [248702]={name="Waylaid Crate: Apprentice Fabrics",     tier="Apprentice", subtier="Fabrics",
        items={{ID.CuredLightHide,2},{ID.BoltOfLinenCloth,20}}},
    [248703]={name="Waylaid Crate: Apprentice Ingots",      tier="Apprentice", subtier="Ingots",
        items={{ID.CopperBar,20},{ID.TinBar,20},{ID.BronzeBar,10}}},
    -- ── JOURNEYMAN ───────────────────────────────────────────
    [248689]={name="Waylaid Crate: Journeyman Curiosities", tier="Journeyman", subtier="Curiosities",
        items={{ID.SoulDust,20},{ID.GreaterAstralEssence,4},{ID.SmallGlowingShard,6},{ID.LargeGlowingShard,2}}},
    [248686]={name="Waylaid Crate: Journeyman Herbs",       tier="Journeyman", subtier="Herbs",
        items={{ID.Stranglekelp,10},{ID.Bruiseweed,10},{ID.WildSteelbloom,10},{ID.GraveMoss,10},{ID.Kingsblood,10}}},
    [248687]={name="Waylaid Crate: Journeyman Ore",         tier="Journeyman", subtier="Ore",
        items={{ID.SilverOre,10},{ID.IronOre,20}}},
    [248688]={name="Waylaid Crate: Journeyman Textiles",    tier="Journeyman", subtier="Textiles",
        items={{ID.WoolCloth,20},{ID.SilkCloth,40},{ID.MediumLeather,20}}},
    [248707]={name="Waylaid Crate: Journeyman Parts",       tier="Journeyman", subtier="Parts",
        items={{ID.BronzeTube,8},{ID.WhirringBronzeGizmo,7},{ID.BronzeFramework,4},{ID.GoldPowerCore,45}}},
    [248705]={name="Waylaid Crate: Journeyman Fabrics",     tier="Journeyman", subtier="Fabrics",
        items={{ID.BoltOfWoolenCloth,6},{ID.BoltOfSilkCloth,10},{ID.CuredMediumHide,2}}},
    [248706]={name="Waylaid Crate: Journeyman Ingots",      tier="Journeyman", subtier="Ingots",
        items={{ID.SilverBar,10},{ID.IronBar,20}}},
    -- ── EXPERT ───────────────────────────────────────────────
    [248694]={name="Waylaid Crate: Expert Curiosities",     tier="Expert", subtier="Curiosities",
        items={{ID.VisionDust,20},{ID.GreaterMysticEssence,4},{ID.SmallRadiantShard,6},{ID.LargeRadiantShard,2}}},
    [248690]={name="Waylaid Crate: Earthly Expert Herbs",   tier="Expert", subtier="Earthly Herbs",
        items={{ID.Liferoot,20},{ID.Fadeleaf,10},{ID.Goldthorn,10},{ID.KhadgarsWhisker,10}}},
    [248691]={name="Waylaid Crate: Flowering Expert Herbs", tier="Expert", subtier="Flowering Herbs",
        items={{ID.Wintersbite,10},{ID.Firebloom,10},{ID.PurpleLotus,20},{ID.ArthasTears,10}}},
    [248692]={name="Waylaid Crate: Expert Ore",             tier="Expert", subtier="Ore",
        items={{ID.GoldOre,10},{ID.MithrilOre,20}}},
    [248693]={name="Waylaid Crate: Expert Textiles",        tier="Expert", subtier="Textiles",
        items={{ID.MageweaveCloth,40},{ID.HeavyLeather,20}}},
    [248710]={name="Waylaid Crate: Expert Parts",           tier="Expert", subtier="Parts",
        items={{ID.IronStrut,8},{ID.MithrilTube,5},{ID.UnstableTrigger,12},{ID.MithrilCasing,5}}},
    [248708]={name="Waylaid Crate: Expert Fabrics",         tier="Expert", subtier="Fabrics",
        items={{ID.BoltOfMageweave,8},{ID.CuredHeavyHide,2}}},
    [248709]={name="Waylaid Crate: Expert Ingots",          tier="Expert", subtier="Ingots",
        items={{ID.MithrilBar,20},{ID.SteelBar,15},{ID.GoldBar,10}}},
    -- ── ARTISAN ──────────────────────────────────────────────
    [248699]={name="Waylaid Crate: Artisan Curiosities",    tier="Artisan", subtier="Curiosities",
        items={{ID.DreamDust,20},{ID.GreaterNetherEssence,4},{ID.SmallBrilliantShard,6},{ID.LargeBrilliantShard,2}}},
    [248695]={name="Waylaid Crate: Earthly Artisan Herbs",  tier="Artisan", subtier="Earthly Herbs",
        items={{ID.GoldenSansam,10},{ID.Sungrass,20},{ID.Blindweed,10},{ID.GhostMushroom,10},{ID.Gromsblood,10}}},
    [248696]={name="Waylaid Crate: Flowering Artisan Herbs",tier="Artisan", subtier="Flowering Herbs",
        items={{ID.Dreamfoil,20},{ID.MountainSilversage,20},{ID.Plaguebloom,20},{ID.Icecap,20}}},
    [248697]={name="Waylaid Crate: Artisan Ore",            tier="Artisan", subtier="Ore",
        items={{ID.TruesilverOre,10},{ID.ThoriumOre,20}}},
    [248698]={name="Waylaid Crate: Artisan Textiles",       tier="Artisan", subtier="Textiles",
        items={{ID.Runecloth,40},{ID.ThickLeather,20},{ID.RuggedLeather,20}}},
    [248713]={name="Waylaid Crate: Artisan Parts",          tier="Artisan", subtier="Parts",
        items={{ID.ThoriumWidget,5},{ID.TruesilverTransformer,5},{ID.ThoriumTube,2}}},
    [248711]={name="Waylaid Crate: Artisan Fabrics",        tier="Artisan", subtier="Fabrics",
        items={{ID.BoltOfRunecloth,8},{ID.CuredThickHide,2}}},
    [248712]={name="Waylaid Crate: Artisan Ingots",         tier="Artisan", subtier="Ingots",
        items={{ID.DarkIronBar,2},{ID.TruesilverBar,10},{ID.ThoriumBar,20}}},
}

-- Ordered list of crate IDs for display (tier then subtier order)
WCA.CRATE_ORDER = {
    248685,248682,248683,248684,248704,248702,248703, -- Apprentice
    248689,248686,248687,248688,248707,248705,248706, -- Journeyman
    248694,248690,248691,248692,248693,248710,248708,248709, -- Expert
    248699,248695,248696,248697,248698,248713,248711,248712, -- Artisan
}


-- Merchant's Favour per turn-in, by tier and subtier quality
-- Uncommon subtiers (Fabrics, Ingots, Parts) give double
local UNCOMMON_SUBTIERS = { Fabrics=true, Ingots=true, Parts=true }
local TIER_BASE_MF = { Apprentice=5, Journeyman=10, Expert=15, Artisan=20 }

function WCA:GetMerchantsFavour(crateID)
    local data = self.CRATES[crateID]
    if not data then return nil end
    local base = TIER_BASE_MF[data.tier]
    if not base then return nil end
    if UNCOMMON_SUBTIERS[data.subtier] then
        return base * 2
    end
    return base
end

-- ============================================================
-- PRICE LOOKUP
-- ============================================================
function WCA:GetPrice(itemID)
    if Auctionator and Auctionator.API and Auctionator.API.v1 then
        local ok, price = pcall(Auctionator.API.v1.GetAuctionPriceByItemID, ADDON_NAME, itemID)
        if ok and price and price > 0 then return price end
    end
    if AUCTIONATOR_PRICE_DATABASE then
        local realm = GetRealmName() .. " " .. (UnitFactionGroup("player") or "")
        local realmDB = AUCTIONATOR_PRICE_DATABASE[realm]
        if type(realmDB) == "table" then
            local entry = realmDB[tostring(itemID)]
            if type(entry) == "table" and entry.m and entry.m > 0 then return entry.m end
        end
    end
    return nil
end

-- Returns the AH price of the crate itself from Auctionator, or nil.
function WCA:GetCratePrice(crateID)
    return self:GetPrice(crateID)
end

-- Returns the cheapest fill option: { itemID, qty, name, unitPrice, totalCost }
-- or nil if no prices are known.
function WCA:CheapestFill(crateID)
    local data = self.CRATES[crateID]
    if not data then return nil end

    local best = nil
    for _, pair in ipairs(data.items) do
        local itemID, qty = pair[1], pair[2]
        local price = self:GetPrice(itemID)
        if price then
            local total = price * qty
            if best == nil or total < best.totalCost then
                local name = select(1, C_Item.GetItemInfo(itemID)) or ("Item #%d"):format(itemID)
                best = { itemID=itemID, qty=qty, name=name, unitPrice=price, totalCost=total }
            end
        end
    end
    return best
end

-- ============================================================
-- MONEY FORMATTING
-- ============================================================
function WCA:Coins(copper)
    if not copper then return "|cffaaaaaa—|r" end
    local g = math.floor(copper / 10000)
    local s = math.floor((copper % 10000) / 100)
    local c = copper % 100
    local parts = {}
    if g > 0 then parts[#parts+1] = ("|cffffd700%dg|r"):format(g) end
    if s > 0 then parts[#parts+1] = ("|cffc0c0c0%ds|r"):format(s) end
    if c > 0 or #parts == 0 then parts[#parts+1] = ("|cffb87333%dc|r"):format(c) end
    return table.concat(parts, " ")
end

local TIER_COLOR = {Apprentice="|cff1eff00", Journeyman="|cff0070dd", Expert="|cffa335ee", Artisan="|cffff8000"}

-- ============================================================
-- TOOLTIP HOOK
-- ============================================================
local function AddCrateTooltip(tooltip)
    local _, link = tooltip:GetItem()
    if not link then return end
    local itemID = tonumber(link:match("item:(%d+)"))
    if not itemID then return end
    local data = WCA.CRATES[itemID]
    if not data then return end

    local best = WCA:CheapestFill(itemID)
    local col  = TIER_COLOR[data.tier] or "|r"

    tooltip:AddLine(" ")
    tooltip:AddLine(("%s[WCA] %s — %s|r"):format(col, data.tier, data.subtier))

    if best then
        tooltip:AddDoubleLine("Cheapest fill:", WCA:Coins(best.totalCost), 1,0.82,0, 1,0.82,0)
        tooltip:AddDoubleLine(("  x%d %s"):format(best.qty, best.name),
            WCA:Coins(best.unitPrice).." ea", 0.85,0.85,0.85, 0.85,0.85,0.85)
        local cratePrice = WCA:GetCratePrice(itemID)
        local mf = WCA:GetMerchantsFavour(itemID)
        if cratePrice and cratePrice > 0 then
            tooltip:AddDoubleLine("Crate AH price:", WCA:Coins(cratePrice), 0.7,0.7,0.7, 0.7,0.7,0.7)
            local totalCost = cratePrice + best.totalCost
            tooltip:AddDoubleLine("Total cost:", WCA:Coins(totalCost), 1,0.82,0, 1,0.82,0)
            if mf and mf > 0 then
                tooltip:AddDoubleLine("Cost per MF ("..mf.." MF):", WCA:Coins(math.floor(totalCost / mf)), 1,1,0.4, 1,1,0.4)
            end
        else
            if mf and mf > 0 then
                tooltip:AddDoubleLine("Cost per MF ("..mf.." MF)*:", WCA:Coins(math.floor(best.totalCost / mf)), 1,1,0.4, 1,1,0.4)
                tooltip:AddLine("|cff888888* fill cost only, no crate price|r")
            end
        end
    else
        tooltip:AddLine("|cffaaaaaa(no Auctionator data — run a scan)|r")
    end
    tooltip:AddLine("|cff555555/wca for full list|r")
    tooltip:Show()
end

-- ============================================================
-- GUI — WoW Classic parchment style
-- ============================================================

local MainFrame
local ROW_FRAMES = {}

local TIER_SECTIONS = {
    {tier="Apprentice", label="Apprentice  (Level 10)"},
    {tier="Journeyman", label="Journeyman  (Level 10)"},
    {tier="Expert",     label="Expert  (Level 20)"},
    {tier="Artisan",    label="Artisan  (Level 35)"},
}

-- Column x positions (left edge of each column within the scroll child)
-- Frame is 760px wide; scroll child usable width ~700px after borders+scrollbar
local COL = { subtier=10, item=155, cost=355, sell=450, totalcost=535, costpermf=625 }
local COL_W = { subtier=143, item=198, cost=93, sell=83, totalcost=88, costpermf=90 }

local function MakeClassicFrame()
    if MainFrame then return MainFrame end

    local f = CreateFrame("Frame", "WCAMainFrame", UIParent)
    f:SetSize(760, 460)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)

    -- Background: tiled parchment texture
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
    bg:SetPoint("TOPLEFT",     12,  -12)
    bg:SetPoint("BOTTOMRIGHT", -12,  12)
    bg:SetVertexColor(1, 0.88, 0.65, 1)  -- warm parchment tint

    -- Border: nine separate textures (top-left, top, top-right, left, right, bot-left, bot, bot-right)
    local function AddBorderPiece(layer, point, relPoint, xOff, yOff, w, h, texCoord)
        local t = f:CreateTexture(nil, layer)
        t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Border")
        t:SetSize(w, h)
        t:SetPoint(point, f, relPoint, xOff, yOff)
        if texCoord then t:SetTexCoord(unpack(texCoord)) end
        return t
    end
    -- corners (64x64 regions of the border sheet)
    --AddBorderPiece("OVERLAY","TOPLEFT",    "TOPLEFT",     0,  0, 64,64, {0,   0.25, 0,    0.25})
    --AddBorderPiece("OVERLAY","TOPRIGHT",   "TOPRIGHT",    0,  0, 64,64, {0.75,1,    0,    0.25})
    --AddBorderPiece("OVERLAY","BOTTOMLEFT", "BOTTOMLEFT",  0,  0, 64,64, {0,   0.25, 0.75, 1   })
    --AddBorderPiece("OVERLAY","BOTTOMRIGHT","BOTTOMRIGHT",  0,  0, 64,64, {0.75,1,    0.75, 1   })

    -- Title bar texture strip
    local titleBg = f:CreateTexture(nil, "ARTWORK")
    titleBg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    titleBg:SetPoint("TOP", 0, 12)
    titleBg:SetSize(400, 64)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -2)
    title:SetText("|cffffd100Waylaid Crate Advisor|r")

    -- Close button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -3, -3)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- Refresh button  
    local refreshBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    refreshBtn:SetSize(90, 22)
    refreshBtn:SetPoint("BOTTOMRIGHT", -16, 14)
    refreshBtn:SetText("Refresh")
    refreshBtn:SetScript("OnClick", function() WCA:RebuildRows() end)

    -- Scroll frame
    local scroll = CreateFrame("ScrollFrame", "WCAScrollFrame", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT",     14, -42)
    scroll:SetPoint("BOTTOMRIGHT", -32, 40)

    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(scroll:GetWidth(), 10)
    scroll:SetScrollChild(child)

    -- Column headers
    local headerY = -4
    local function Header(text, x, w)
        local fs = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", x, headerY)
        fs:SetWidth(w)
        fs:SetJustifyH("CENTER")
        fs:SetText("|cffd4a017"..text.."|r")
    end
    Header("Crate",         COL.subtier, COL_W.subtier)
    Header("Cheapest fill item", COL.item,     COL_W.item)
    Header("Fill cost",     COL.cost,     COL_W.cost)
    Header("Crate price",      COL.sell,     COL_W.sell)
    Header("Total cost",    COL.totalcost, COL_W.totalcost)
    Header("Cost/MF",       COL.costpermf, COL_W.costpermf)

    -- Thin divider under headers
    local div = child:CreateTexture(nil, "OVERLAY")
    div:SetColorTexture(0.5, 0.38, 0.15, 0.6)
    div:SetPoint("TOPLEFT",  0, headerY - 14)
    div:SetPoint("TOPRIGHT", 0, headerY - 14)
    div:SetHeight(1)

    f.scroll  = scroll
    f.child   = child
    f.baseY   = headerY - 18  -- content starts below header+divider
    MainFrame = f
    return f
end

-- Creates or recycles a single data row
local function GetRow(child, idx)
    if ROW_FRAMES[idx] then return ROW_FRAMES[idx] end
    local row = {}

    local function FS(anchor, x, w, justify)
        local fs = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", x, 0)   -- y set by caller via :SetPoint
        fs:SetWidth(w)
        fs:SetJustifyH(justify or "LEFT")
        return fs
    end

    row.subtier   = FS(child, COL.subtier,  COL_W.subtier)
    row.item      = FS(child, COL.item,     COL_W.item)
    row.cost      = FS(child, COL.cost,     COL_W.cost,     "RIGHT")
    row.sell      = FS(child, COL.sell,     COL_W.sell,     "RIGHT")
    row.totalcost = FS(child, COL.totalcost,COL_W.totalcost,"RIGHT")
    row.costpermf = FS(child, COL.costpermf,COL_W.costpermf,"RIGHT")

    -- zebra stripe background
    row.bg = child:CreateTexture(nil, "BACKGROUND")
    row.bg:SetColorTexture(0, 0, 0, 0)  -- default transparent; set per-row

    ROW_FRAMES[idx] = row
    return row
end

function WCA:RebuildRows()
    local f = MakeClassicFrame()
    local child = f.child

    -- Hide all existing rows
    for _, row in ipairs(ROW_FRAMES) do
        for k, fs in pairs(row) do
            if k ~= "bg" and fs.SetText then fs:SetText("") end
        end
        row.bg:SetColorTexture(0,0,0,0)
    end

    local LH      = 16   -- row height
    local SECT_H  = 20   -- section header height
    local y        = f.baseY
    local rowIdx   = 0

    local currentTier = nil

    for _, crateID in ipairs(self.CRATE_ORDER) do
        local data = self.CRATES[crateID]
        if data then

        -- Section divider when tier changes
        if data.tier ~= currentTier then
            currentTier = data.tier

            -- Find the label for this tier
            local label = data.tier
            for _, sec in ipairs(TIER_SECTIONS) do
                if sec.tier == data.tier then label = sec.label break end
            end

            -- Section header font string
            local tierCol = TIER_COLOR[data.tier] or "|r"
            local secFS = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            secFS:SetPoint("TOPLEFT", COL.subtier, y)
            secFS:SetWidth(530)
            secFS:SetText(tierCol .. label .. "|r")
            y = y - SECT_H

            -- Section underline
            local ul = child:CreateTexture(nil, "OVERLAY")
            ul:SetColorTexture(0.55, 0.40, 0.12, 0.5)
            ul:SetPoint("TOPLEFT",  COL.subtier, y + 2)
            ul:SetPoint("TOPRIGHT", -4,           y + 2)
            ul:SetHeight(1)
            y = y - 4
        end

        rowIdx = rowIdx + 1
        local row = GetRow(child, rowIdx)

        -- Reposition all fields for this row
        for _, fs in pairs(row) do
            if fs.SetPoint then fs:ClearAllPoints() end
        end
        row.bg:ClearAllPoints()

        -- Zebra stripe
        if rowIdx % 2 == 0 then
            row.bg:SetColorTexture(0.2, 0.15, 0.05, 0.18)
        else
            row.bg:SetColorTexture(0, 0, 0, 0)
        end
        row.bg:SetPoint("TOPLEFT",  0,    y)
        row.bg:SetPoint("TOPRIGHT", 0,    y)
        row.bg:SetHeight(LH)

        -- Subtier label
        row.subtier:SetPoint("TOPLEFT", COL.subtier, y)
        row.subtier:SetText(data.subtier)
        row.subtier:SetTextColor(0.9, 0.82, 0.6)

        -- Cheapest fill
        local best = self:CheapestFill(crateID)
        if best then
            row.item:SetPoint("TOPLEFT", COL.item, y)
            row.item:SetText(("|cffFFFFFF x%d|r %s"):format(best.qty, best.name))

            row.cost:SetPoint("TOPLEFT", COL.cost, y)
            row.cost:SetText(self:Coins(best.totalCost))

            local cratePrice = self:GetCratePrice(crateID)
            local mf = self:GetMerchantsFavour(crateID)

            if cratePrice and cratePrice > 0 then
                row.sell:SetPoint("TOPLEFT", COL.sell, y)
                row.sell:SetText(self:Coins(cratePrice))

                local totalCost = cratePrice + best.totalCost
                row.totalcost:SetPoint("TOPLEFT", COL.totalcost, y)
                row.totalcost:SetText(self:Coins(totalCost))

                if mf and mf > 0 then
                    row.costpermf:SetPoint("TOPLEFT", COL.costpermf, y)
                    row.costpermf:SetText(self:Coins(math.floor(totalCost / mf)))
                else
                    row.costpermf:SetPoint("TOPLEFT", COL.costpermf, y)
                    row.costpermf:SetText("|cff888888—|r")
                end
            else
                row.sell:SetPoint("TOPLEFT", COL.sell, y)
                row.sell:SetText("|cff888888—|r")
                row.totalcost:SetPoint("TOPLEFT", COL.totalcost, y)
                row.totalcost:SetText("|cff888888—|r")
                -- Can still show cost/mf using fill cost alone if no crate price
                if mf and mf > 0 then
                    row.costpermf:SetPoint("TOPLEFT", COL.costpermf, y)
                    row.costpermf:SetText(self:Coins(math.floor(best.totalCost / mf)).."*")
                else
                    row.costpermf:SetPoint("TOPLEFT", COL.costpermf, y)
                    row.costpermf:SetText("|cff888888—|r")
                end
            end
        else
            row.item:SetPoint("TOPLEFT", COL.item, y)
            row.item:SetText("|cff888888No price data|r")
            row.cost:SetPoint("TOPLEFT", COL.cost, y)
            row.cost:SetText("")
            row.sell:SetPoint("TOPLEFT", COL.sell, y)
            row.sell:SetText("")
            row.totalcost:SetPoint("TOPLEFT", COL.totalcost, y)
            row.totalcost:SetText("")
            row.costpermf:SetPoint("TOPLEFT", COL.costpermf, y)
            row.costpermf:SetText("")
        end

        y = y - LH
        end -- if data
    end

    -- Footer note
    local footerFS = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footerFS:SetPoint("TOPLEFT", COL.subtier, y - 4)
    footerFS:SetWidth(530)
    footerFS:SetText("|cff888888Prices from Auctionator  •  cheapest fill shown  •  * = fill cost only (no crate AH price)  •  /wca to refresh|r")
    y = y - 20

    child:SetSize(f.scroll:GetWidth(), math.abs(y) + 10)
    f:Show()
end

local function ToggleFrame()
    if MainFrame and MainFrame:IsShown() then
        MainFrame:Hide()
    else
        local ok, err = pcall(function() WCA:RebuildRows() end)
        if not ok then print("|cffff0000WCA error:|r " .. tostring(err)) end
    end
end

-- ============================================================
-- SLASH COMMANDS
-- ============================================================
SLASH_WAYLAIDCRATEADVISOR1 = "/wca"
SLASH_WAYLAIDCRATEADVISOR2 = "/crates"
SlashCmdList["WAYLAIDCRATEADVISOR"] = function(msg)
    msg = (msg or ""):trim():lower()

    if msg == "id" then
        local name, link = GameTooltip:GetItem()
        if link then
            local id = link:match("item:(%d+)")
            print(("|cff00ff96WCA:|r %s  —  ID: |cffffff00%s|r"):format(name or "?", id or "?"))
        else
            print("|cff00ff96WCA:|r Hover an item first, then run /wca id")
        end
        return
    end

    if msg == "prices" then
        print("|cff00ff96WCA: Auctionator price check — fill items|r")
        local seen = {}
        for _, crateID in ipairs(WCA.CRATE_ORDER) do
            local data = WCA.CRATES[crateID]
            if data then
                for _, pair in ipairs(data.items) do
                    local itemID = pair[1]
                    if not seen[itemID] then
                        seen[itemID] = true
                        local name  = select(1, C_Item.GetItemInfo(itemID)) or ("Item #%d"):format(itemID)
                        local price = WCA:GetPrice(itemID)
                        print(("  [%d] %s: %s"):format(itemID, name, price and WCA:Coins(price) or "|cffaaaaaa(no data)|r"))
                    end
                end
            end
        end
        print("|cff00ff96WCA: Auctionator price check — crates|r")
        for _, crateID in ipairs(WCA.CRATE_ORDER) do
            local data = WCA.CRATES[crateID]
            if data then
                local price = WCA:GetCratePrice(crateID)
                local best  = WCA:CheapestFill(crateID)
                local mf    = WCA:GetMerchantsFavour(crateID)
                print(("  [%d] %s"):format(crateID, data.subtier))
                print(("    Crate AH price: %s"):format(price and WCA:Coins(price) or "|cffaaaaaa(no data)|r"))
                print(("    Cheapest fill:  %s"):format(best and WCA:Coins(best.totalCost) or "|cffaaaaaa(no data)|r"))
                print(("    MF reward:      %s"):format(mf and tostring(mf) or "|cffaaaaaa(nil)|r"))
                if best and mf then
                    local total = (price or 0) + best.totalCost
                    print(("    Cost/MF:        %s"):format(WCA:Coins(math.floor(total / mf))))
                end
            end
        end
        return
    end

    if msg == "help" then
        print("|cff00ff96WaylaidCrateAdvisor|r commands:")
        print("  /wca            Toggle the crate list window")
        print("  /crates         Same as /wca")
        print("  /wca id         Print item ID of hovered item")
        print("  /wca prices     Dump Auctionator prices for all fill items")
        print("  /wca help       This help text")
        return
    end

    ToggleFrame()
end

-- ============================================================
-- INITIALIZATION
-- ============================================================
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event ~= "ADDON_LOADED" or arg1 ~= ADDON_NAME then return end

    local ok, err = pcall(function()
        hooksecurefunc(GameTooltip, "SetBagItem", function(tooltip, bag, slot)
            local info = C_Container.GetContainerItemInfo(bag, slot)
            local link = info and info.hyperlink
            if link then
                local itemID = tonumber(link:match("item:(%d+)"))
                if itemID and WCA.CRATES[itemID] then AddCrateTooltip(tooltip) end
            end
        end)

        hooksecurefunc(GameTooltip, "SetHyperlink", function(tooltip, link)
            if link then
                local itemID = tonumber(link:match("item:(%d+)"))
                if itemID and WCA.CRATES[itemID] then AddCrateTooltip(tooltip) end
            end
        end)

        -- Pre-cache item names
        for _, crateID in ipairs(WCA.CRATE_ORDER) do
            local data = WCA.CRATES[crateID]
            if data then
                for _, pair in ipairs(data.items) do
                    C_Item.GetItemInfo(pair[1])
                end
            end
        end
    end)

    if not ok then
        print("|cffff0000WaylaidCrateAdvisor load error:|r " .. tostring(err))
    else
        print("|cff00ff96WaylaidCrateAdvisor 3.2.2|r loaded  —  /wca to open, /wca help for options")
    end
end)
