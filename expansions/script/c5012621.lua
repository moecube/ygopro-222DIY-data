--托尔
function c5012621.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1e0)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCountLimit(1,5012621)
    e1:SetCost(c5012621.spcost)
    e1:SetTarget(c5012621.sptg)
    e1:SetOperation(c5012621.spop)
    c:RegisterEffect(e1)  
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(5012621,0))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,5012621)
    e2:SetCost(c5012621.recost)
    e2:SetTarget(c5012621.target)
    e2:SetOperation(c5012621.operation)
    c:RegisterEffect(e2)
 --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(5012621,1))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,5012621)
    e3:SetCondition(c5012621.discon)
    e3:SetCost(c5012621.discost)
    e3:SetTarget(c5012621.distg)
    e3:SetOperation(c5012621.disop)
    c:RegisterEffect(e3)
end 
function c5012621.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c5012621.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c5012621.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c5012621.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end  
function c5012621.cfilter(c)
    return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x250)
end
function c5012621.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then
        if ft<0 then return false end
        if ft==0 then
            return Duel.IsExistingMatchingCard(c5012621.cfilter,tp,LOCATION_MZONE,0,1,nil)
        else
            return Duel.IsExistingMatchingCard(c5012621.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    if ft==0 then
        local g=Duel.SelectMatchingCard(tp,c5012621.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_COST)
    else
        local g=Duel.SelectMatchingCard(tp,c5012621.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_COST)
    end
end
function c5012621.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c5012621.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
        Duel.SendtoGrave(c,REASON_RULE)
        return
    end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end 
function c5012621.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5012621.defilter(c)
    return  c:IsSetCard(0x250) 
end
function c5012621.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5012621.defilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c5012621.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c5012621.defilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end