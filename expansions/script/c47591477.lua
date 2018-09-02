--觉醒十天众 希耶提
local m=47591477
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0x5d6)
    --xyz summon
    aux.AddXyzProcedure(c,nil,7,3,c47591477.ovfilter,aux.Stringid(47591477,0),3,c47591477.xyzop)
    c:EnableReviveLimit()
    --serch
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47591477,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47591477)
    e1:SetCondition(c47591477.poscon)
    e1:SetTarget(c47591477.thtg)
    e1:SetOperation(c47591477.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --kenkou
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47591477,1))
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47591477.opd1)
    c:RegisterEffect(e3)
    --atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c47591477.attackup)
    c:RegisterEffect(e4)
    --extra atk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EXTRA_ATTACK)
    e5:SetValue(c47591477.ta)
    c:RegisterEffect(e5)
    --destroy replace
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTarget(c47591477.reptg)
    c:RegisterEffect(e6)
end
function c47591477.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5d1) and not c:IsCode(47591477)
end
function c47591477.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,47591477)==0 end
    Duel.RegisterFlagEffect(tp,47591477,RESET_PHASE+PHASE_END,0,1)
end
function c47591477.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47591477.filter(c)
    return c:IsCode(47591007) and c:IsAbleToHand()
end
function c47591477.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591477.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47591477.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591477.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47591477.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5d6,2)
    end
end
function c47591477.attackup(e,c)
    return c:GetCounter(0x5d6)*1000
end
function c47591477.ta(e,c)
    return c:GetCounter(0x5d6)*1-1
end
function c47591477.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end