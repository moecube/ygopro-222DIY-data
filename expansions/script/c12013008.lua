--火枪手
function c12013008.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12013008,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetCondition(c12013008.excon)
	e1:SetTarget(c12013008.extg)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12013008,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12013008)
	e2:SetCondition(c12013008.thcon2)
	e2:SetTarget(c12013008.thtg2)
	e2:SetOperation(c12013008.thop2)
	c:RegisterEffect(e2)
end
function c12013008.exfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xfb6)
end
function c12013008.excon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12013008.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12013008.extg(e,c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_PLANT)
end
function c12013008.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12013008.thfilter2(c,tp)
	return c:IsCode(12013005) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c12013008.thfilter3,tp,LOCATION_DECK,0,1,c)
end
function c12013008.thfilter3(c)
	return c:IsSetCard(0xfb6) and c:IsType(TYPE_MONSTER) and c:GetLevel()==2 and c:IsAbleToHand()
end
function c12013008.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12013008.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12013008.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c12013008.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c12013008.thfilter3,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
