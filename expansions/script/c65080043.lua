--失落之妖精 艾尔兰缇娅
function c65080043.initial_effect(c)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65080043,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c65080043.cost)
	e2:SetOperation(c65080043.operation)
	c:RegisterEffect(e2)
end
function c65080043.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and not c:IsPublic()
end
function c65080043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080043.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c65080043.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.ShuffleHand(tp)
end
function c65080043.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetLabel(e:GetLabel()+1)
	e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
	e1:SetTarget(c65080043.val)
	Duel.RegisterEffect(e1,tp)
end
function c65080043.val(e,c)
	return c:IsLevelAbove(e:GetLabel())
end