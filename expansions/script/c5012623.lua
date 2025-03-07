--冥土追魂
function c5012623.initial_effect(c)
    --cannot special summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x250),2,2)
    c:EnableReviveLimit()
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(5012623,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,5012623)
    e1:SetCost(c5012623.spcost)
    e1:SetTarget(c5012623.sptg)
    e1:SetOperation(c5012623.spop)
    c:RegisterEffect(e1)
end
function c5012623.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c5012623.filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5012623.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c5012623.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c5012623.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c5012623.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c5012623.spop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end 
