--精灵剑舞变换
function c5200019.initial_effect(c)
   --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,5200019+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c5200019.target)
    e1:SetOperation(c5200019.operation)
    c:RegisterEffect(e1)
end
function c5200019.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x360) and c:IsAbleToDeck()
        and Duel.IsExistingMatchingCard(c5200019.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c5200019.spfilter(c,e,tp,code)
    return c:IsSetCard(0x360) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5200019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c5200019.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and Duel.IsExistingTarget(c5200019.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c5200019.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5200019.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<=0 then return end
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c5200019.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
        end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetAbsoluteRange(tp,1,0)
        e1:SetTarget(c5200019.splimit)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        g:GetFirst():RegisterEffect(e1,true)
    end
end
function c5200019.splimit(e,c)
    return not c:IsSetCard(0x360)
end
