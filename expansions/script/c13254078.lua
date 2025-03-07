--禁忌飞球·地狱之门
function c13254078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13254078.pctg)
	e1:SetOperation(c13254078.pcop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,13254078)
	e2:SetCost(c13254078.cost)
	e2:SetTarget(c13254078.target2)
	e2:SetOperation(c13254078.activate2)
	c:RegisterEffect(e2)
	
end
function c13254078.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5356) and not c:IsForbidden() and c:IsLevelBelow(2)
end
function c13254078.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x356) and c:IsReleasable()
end
function c13254078.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254078.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,nil) and Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7)
		and Duel.IsExistingMatchingCard(c13254078.pcfilter,tp,LOCATION_EXTRA,0,2,nil) end
end
function c13254078.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not(Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7)) and e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c13254078.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,2,nil)
	if Duel.Release(rg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c13254078.pcfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	local pc=g:GetFirst()
	while pc do
		Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		pc=g:GetNext()
	end
end
function c13254078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c13254078.tgfilter2(c)
	return c:IsCode(13254062) and c:IsAbleToGrave()
end
function c13254078.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254078.tgfilter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c13254078.activate2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c13254078.tgfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
