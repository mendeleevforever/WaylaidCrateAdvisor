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
    if not copper then return "|cff7d705a—|r" end
    local g = math.floor(copper / 10000)
    local s = math.floor((copper % 10000) / 100)
    local c = copper % 100
    local parts = {}
    if g > 0 then parts[#parts+1] = g .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t" end
    if s > 0 then parts[#parts+1] = s .. "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t" end
    if c > 0 or #parts == 0 then parts[#parts+1] = c .. "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t" end
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
-- GUI — dark leather window with gold trim
-- ============================================================

local MainFrame
local ROW_POOL     = {}   -- recycled data rows
local SECTION_POOL = {}   -- recycled tier headers

local WINDOW_W, WINDOW_H = 880, 640
local ROW_H, SECTION_H   = 18, 26
local SCROLL_LEFT        = 20     -- scroll area inset from the window's left edge
local CHILD_W            = 810    -- width of the scrolling content

-- Palette (r, g, b)
local C = {
    bg        = { 0.118, 0.082, 0.051 },
    gold      = { 0.541, 0.416, 0.173 },
    goldLight = { 0.722, 0.569, 0.235 },
    outline   = { 0.169, 0.118, 0.055 },
    inner     = { 0.290, 0.212, 0.094 },
    rule      = { 0.420, 0.314, 0.137 },
    header    = { 0.831, 0.627, 0.090 },
    text      = { 0.902, 0.839, 0.682 },
    money     = { 0.937, 0.894, 0.784 },
    muted     = { 0.612, 0.553, 0.439 },
    mf        = { 0.788, 0.725, 0.561 },
    cpm       = { 1.000, 0.957, 0.816 },
}

local TIER_INFO = {
    Apprentice = { color = { 0.118, 1.000, 0.000 }, level = "Level 10" },
    Journeyman = { color = { 0.290, 0.639, 1.000 }, level = "Level 10" },
    Expert     = { color = { 0.761, 0.482, 1.000 }, level = "Level 20" },
    Artisan    = { color = { 1.000, 0.604, 0.180 }, level = "Level 35" },
}

-- Column layout inside the scroll child: x = left edge, w = width
local COLS = {
    rank   = { x = 6,   w = 18  },
    crate  = { x = 30,  w = 124 },
    item   = { x = 160, w = 200 },
    fill   = { x = 366, w = 84,  right = true },
    ah     = { x = 458, w = 80,  right = true },
    total  = { x = 546, w = 88,  right = true },
    mf     = { x = 642, w = 36,  right = true },
    cpm    = { x = 686, w = 110, right = true },
}

-- Rank highlight: coin icon, row tint (r,g,b,a), label/value colour
local RANK_STYLE = {
    { icon = "Interface\\MoneyFrame\\UI-GoldIcon",   tint = { 1.00, 0.82, 0.00, 0.20 }, color = { 1.00, 0.82, 0.00 } },
    { icon = "Interface\\MoneyFrame\\UI-SilverIcon", tint = { 0.78, 0.78, 0.84, 0.18 }, color = { 0.78, 0.78, 0.82 } },
    { icon = "Interface\\MoneyFrame\\UI-CopperIcon", tint = { 0.77, 0.45, 0.23, 0.24 }, color = { 0.77, 0.45, 0.23 } },
}

-- Draws a rectangular border of the given thickness, `inset` px inside the frame edge
-- (negative inset draws outside it).
local function AddBorder(frame, layer, rgb, alpha, thickness, inset)
    local function edge()
        local t = frame:CreateTexture(nil, layer)
        t:SetColorTexture(rgb[1], rgb[2], rgb[3], alpha)
        return t
    end
    local top, bottom, left, right = edge(), edge(), edge(), edge()
    top:SetPoint("TOPLEFT", inset, -inset)
    top:SetPoint("TOPRIGHT", -inset, -inset)
    top:SetHeight(thickness)
    bottom:SetPoint("BOTTOMLEFT", inset, inset)
    bottom:SetPoint("BOTTOMRIGHT", -inset, inset)
    bottom:SetHeight(thickness)
    left:SetPoint("TOPLEFT", inset, -inset)
    left:SetPoint("BOTTOMLEFT", inset, inset)
    left:SetWidth(thickness)
    right:SetPoint("TOPRIGHT", -inset, -inset)
    right:SetPoint("BOTTOMRIGHT", -inset, inset)
    right:SetWidth(thickness)
end

local function NewText(parent, font, col, xOffset, layer)
    local fs = parent:CreateFontString(nil, layer or "OVERLAY", font or "GameFontNormalSmall")
    fs:SetWidth(col.w)
    fs:SetJustifyH(col.right and "RIGHT" or "LEFT")
    fs:SetWordWrap(false)
    fs.colX = col.x + (xOffset or 0)
    return fs
end

local function MakeMainFrame()
    if MainFrame then return MainFrame end

    local f = CreateFrame("Frame", "WCAMainFrame", UIParent)
    f:SetSize(WINDOW_W, WINDOW_H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:Hide()
    tinsert(UISpecialFrames, "WCAMainFrame")   -- Escape closes the window

    -- Solid background (opaque, so the world doesn't show through)
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetColorTexture(C.bg[1], C.bg[2], C.bg[3], 0.97)
    bg:SetAllPoints()

    -- Layered trim: dark outline, gold band, faint inner line
    AddBorder(f, "BORDER",  C.outline, 1,   2, -2)
    AddBorder(f, "BORDER",  C.gold,    1,   3,  0)
    AddBorder(f, "ARTWORK", C.inner,   1,   1,  3)

    -- Title plate overlapping the top edge
    local plate = CreateFrame("Frame", nil, f)
    plate:SetSize(300, 34)
    plate:SetPoint("TOP", 0, 18)
    plate:SetFrameLevel(f:GetFrameLevel() + 5)
    local pbg = plate:CreateTexture(nil, "BACKGROUND")
    pbg:SetColorTexture(0.165, 0.114, 0.063, 1)
    pbg:SetAllPoints()
    AddBorder(plate, "BORDER", C.outline,   1, 2, -2)
    AddBorder(plate, "BORDER", C.goldLight, 1, 2,  0)
    local title = plate:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("CENTER", 0, 0)
    title:SetText("Waylaid Crate Advisor")
    title:SetTextColor(1, 0.82, 0)

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)
    close:SetScript("OnClick", function() f:Hide() end)

    -- Fixed column headers (they don't scroll away)
    local headerY = -40
    local headers = {
        { "crate", "Crate" }, { "item", "Cheapest fill" }, { "fill", "Fill cost" },
        { "ah", "Crate AH" }, { "total", "Total cost" }, { "mf", "MF" }, { "cpm", "Cost / MF" },
    }
    for _, h in ipairs(headers) do
        local col = COLS[h[1]]
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("TOPLEFT", SCROLL_LEFT + col.x, headerY)
        fs:SetWidth(col.w)
        fs:SetJustifyH(col.right and "RIGHT" or "LEFT")
        fs:SetText(h[2])
        if h[1] == "cpm" then
            fs:SetTextColor(1, 0.82, 0)
        else
            fs:SetTextColor(C.header[1], C.header[2], C.header[3])
        end
    end
    local headRule = f:CreateTexture(nil, "ARTWORK")
    headRule:SetColorTexture(C.rule[1], C.rule[2], C.rule[3], 1)
    headRule:SetPoint("TOPLEFT", SCROLL_LEFT, headerY - 18)
    headRule:SetPoint("TOPRIGHT", -20, headerY - 18)
    headRule:SetHeight(1)

    -- Scrolling body; right inset leaves room for the scrollbar inside the trim
    local scroll = CreateFrame("ScrollFrame", "WCAScrollFrame", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", SCROLL_LEFT, headerY - 22)
    scroll:SetPoint("BOTTOMRIGHT", -40, 56)

    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(CHILD_W, 10)
    scroll:SetScrollChild(child)

    -- Footer: rule, legend, Refresh button
    local footRule = f:CreateTexture(nil, "ARTWORK")
    footRule:SetColorTexture(C.rule[1], C.rule[2], C.rule[3], 1)
    footRule:SetPoint("BOTTOMLEFT", SCROLL_LEFT, 48)
    footRule:SetPoint("BOTTOMRIGHT", -20, 48)
    footRule:SetHeight(1)

    local legend = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    legend:SetPoint("BOTTOMLEFT", SCROLL_LEFT + 4, 20)
    legend:SetJustifyH("LEFT")
    legend:SetTextColor(0.72, 0.65, 0.52)
    legend:SetText(
        "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12|t |TInterface\\MoneyFrame\\UI-SilverIcon:12:12|t " ..
        "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12|t  Cheapest Cost / MF" ..
        "      |cff9c8d70EST|r = no crate AH price, fill cost only" ..
        "      Prices from Auctionator"
    )

    local refresh = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    refresh:SetSize(110, 26)
    refresh:SetPoint("BOTTOMRIGHT", -20, 14)
    refresh:SetText("Refresh")
    refresh:SetScript("OnClick", function() WCA:RebuildRows() end)

    f.scroll = scroll
    f.child  = child
    MainFrame = f
    return f
end

local function GetRow(child, idx)
    if ROW_POOL[idx] then return ROW_POOL[idx] end
    local row = {}

    row.bg = child:CreateTexture(nil, "BACKGROUND")
    row.bg:SetHeight(ROW_H)

    row.medal = child:CreateTexture(nil, "ARTWORK")
    row.medal:SetSize(14, 14)

    row.crate = NewText(child, "GameFontNormalSmall", COLS.crate)
    row.item  = NewText(child, "GameFontNormalSmall", COLS.item)
    row.fill  = NewText(child, "GameFontNormalSmall", COLS.fill)
    row.ah    = NewText(child, "GameFontNormalSmall", COLS.ah)
    row.total = NewText(child, "GameFontNormalSmall", COLS.total)
    row.mf    = NewText(child, "GameFontNormalSmall", COLS.mf)
    row.cpm   = NewText(child, "GameFontNormal",      COLS.cpm)

    row.texts = { row.crate, row.item, row.fill, row.ah, row.total, row.mf, row.cpm }
    ROW_POOL[idx] = row
    return row
end

local function GetSection(child, idx)
    if SECTION_POOL[idx] then return SECTION_POOL[idx] end
    local sec = {}
    sec.label = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sec.label:SetJustifyH("LEFT")
    sec.rule = child:CreateTexture(nil, "ARTWORK")
    sec.rule:SetHeight(1)
    SECTION_POOL[idx] = sec
    return sec
end

local function PlaceRow(row, y)
    row.bg:ClearAllPoints()
    row.bg:SetPoint("TOPLEFT", 0, y)
    row.bg:SetPoint("TOPRIGHT", 0, y)
    row.medal:ClearAllPoints()
    row.medal:SetPoint("TOPLEFT", COLS.rank.x, y - 2)
    for _, fs in ipairs(row.texts) do
        fs:ClearAllPoints()
        fs:SetPoint("TOPLEFT", fs.colX, y - 3)
    end
end

local function ShowRow(row, show)
    if show then row.bg:Show() else row.bg:Hide(); row.medal:Hide() end
    for _, fs in ipairs(row.texts) do
        if show then fs:Show() else fs:Hide() end
    end
end

-- Returns crateID -> rank (1..3) for the three lowest Cost/MF crates.
-- Only crates with BOTH a fill price and a crate AH price are ranked,
-- so fill-only (EST) figures can't win by being incomplete.
function WCA:RankCheapestCostPerMF()
    local list = {}
    for _, crateID in ipairs(self.CRATE_ORDER) do
        local best       = self:CheapestFill(crateID)
        local cratePrice = self:GetCratePrice(crateID)
        local mf         = self:GetMerchantsFavour(crateID)
        if best and cratePrice and cratePrice > 0 and mf and mf > 0 then
            list[#list + 1] = { id = crateID, cpm = (cratePrice + best.totalCost) / mf }
        end
    end
    table.sort(list, function(a, b) return a.cpm < b.cpm end)
    local ranks = {}
    for i = 1, math.min(3, #list) do ranks[list[i].id] = i end
    return ranks
end

function WCA:RebuildRows()
    local f     = MakeMainFrame()
    local child = f.child
    local ranks = self:RankCheapestCostPerMF()

    local y, rowIdx, secIdx = -4, 0, 0
    local currentTier

    for _, crateID in ipairs(self.CRATE_ORDER) do
        local data = self.CRATES[crateID]
        if data then
            -- Tier header
            if data.tier ~= currentTier then
                currentTier = data.tier
                secIdx = secIdx + 1
                local sec  = GetSection(child, secIdx)
                local info = TIER_INFO[data.tier] or { color = { 1, 1, 1 }, level = "" }
                local hex  = ("%02x%02x%02x"):format(info.color[1] * 255, info.color[2] * 255, info.color[3] * 255)

                y = y - 6
                sec.label:ClearAllPoints()
                sec.label:SetPoint("TOPLEFT", COLS.rank.x, y)
                sec.label:SetText(("|cff%s%s|r   |cffa8987a%s|r"):format(hex, data.tier, info.level))
                sec.label:Show()
                sec.rule:ClearAllPoints()
                sec.rule:SetPoint("TOPLEFT", 0, y - 16)
                sec.rule:SetPoint("TOPRIGHT", 0, y - 16)
                sec.rule:SetColorTexture(C.gold[1], C.gold[2], C.gold[3], 0.55)
                sec.rule:Show()
                y = y - (SECTION_H - 6)
            end

            rowIdx = rowIdx + 1
            local row = GetRow(child, rowIdx)
            PlaceRow(row, y)
            ShowRow(row, true)

            local rank  = ranks[crateID]
            local style = rank and RANK_STYLE[rank]

            -- Background: rank tint, else zebra stripe
            if style then
                row.bg:SetColorTexture(style.tint[1], style.tint[2], style.tint[3], style.tint[4])
                row.medal:SetTexture(style.icon)
                row.medal:Show()
            else
                if rowIdx % 2 == 0 then
                    row.bg:SetColorTexture(0.353, 0.263, 0.125, 0.22)
                else
                    row.bg:SetColorTexture(0, 0, 0, 0)
                end
                row.medal:Hide()
            end

            -- Crate name
            if style then
                row.crate:SetText(("%d. %s"):format(rank, data.subtier))
                row.crate:SetTextColor(style.color[1], style.color[2], style.color[3])
            else
                row.crate:SetText(data.subtier)
                row.crate:SetTextColor(C.text[1], C.text[2], C.text[3])
            end

            local mf         = self:GetMerchantsFavour(crateID)
            local best       = self:CheapestFill(crateID)
            local cratePrice = self:GetCratePrice(crateID)
            local hasAH      = cratePrice and cratePrice > 0

            row.mf:SetText(mf and tostring(mf) or "")
            row.mf:SetTextColor(C.mf[1], C.mf[2], C.mf[3])

            for _, fs in ipairs({ row.fill, row.ah, row.total }) do
                fs:SetTextColor(C.money[1], C.money[2], C.money[3])
            end

            if best then
                row.item:SetText(("|cffffffffx%d|r |cffffd100%s|r"):format(best.qty, best.name))
                row.fill:SetText(self:Coins(best.totalCost))

                if hasAH then
                    local total = cratePrice + best.totalCost
                    row.ah:SetText(self:Coins(cratePrice))
                    row.total:SetText(self:Coins(total))
                    row.cpm:SetText(mf and mf > 0 and self:Coins(math.floor(total / mf)) or "")
                    if style then
                        row.cpm:SetTextColor(style.color[1], style.color[2], style.color[3])
                    else
                        row.cpm:SetTextColor(C.cpm[1], C.cpm[2], C.cpm[3])
                    end
                else
                    row.ah:SetText("|cff7d705a—|r")
                    row.total:SetText("|cff7d705a—|r")
                    row.cpm:SetText(mf and mf > 0
                        and ("|cff9c8d70EST|r  " .. self:Coins(math.floor(best.totalCost / mf))) or "")
                    row.cpm:SetTextColor(C.muted[1], C.muted[2], C.muted[3])
                end
            else
                row.item:SetText("|cff8a7c62No price data|r")
                row.fill:SetText("")
                row.ah:SetText("")
                row.total:SetText("")
                row.cpm:SetText("")
            end

            y = y - ROW_H
        end
    end

    -- Hide anything left over from a previous, longer build
    for i = rowIdx + 1, #ROW_POOL do ShowRow(ROW_POOL[i], false) end
    for i = secIdx + 1, #SECTION_POOL do
        SECTION_POOL[i].label:Hide()
        SECTION_POOL[i].rule:Hide()
    end

    child:SetSize(CHILD_W, math.abs(y) + 8)
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
        print("|cff00ff96WaylaidCrateAdvisor 4.0|r loaded  —  /wca to open, /wca help for options")
    end
end)
