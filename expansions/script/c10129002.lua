--地狱狩人 喀德那
function c10129002.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10129002,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c10129002.thcon)
	e1:SetTarget(c10129002.thtg)
	e1:SetOperation(c10129002.thop)
	c:RegisterEffect(e1)  
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10129002,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10129002.thcon2)
	e2:SetTarget(c10129002.thtg2)
	e2:SetOperation(c10129002.thop2)
	c:RegisterEffect(e2)	  
end
function c10129002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION 
end
function c10129002.thfilter(c)
	return c:GetLevel()==1 and c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function c10129002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10129002.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10129002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10129002.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10129002.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_REMOVED) and r==REASON_FUSION 
end
function c10129002.setfilter(c)
	return c:IsCode(10129006,10129007) and c:IsSSetable()
end
function c10129002.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10129002.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10129002.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10129002.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
	   Duel.SSet(tp,tc)
	   Duel.ConfirmCards(1-tp,tc)
	   local ae=tc:GetActivateEffect()
	   ae:SetProperty(0,EFFECT_FLAG2_COF)
	   ae:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
	   ae:SetCondition(c10129002.con)
	   tc:RegisterFlagEffect(10129002,RESET_EVENT+0x1fe0000,0,1)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_ADJUST)
	   e1:SetOperation(c10129002.resetop)
	   e1:SetLabelObject(tc)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c10129002.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(10129002)==0 then
	   local ae=tc:GetActivateEffect()
	   ae:SetProperty(nil)
	   ae:SetHintTiming(0)
	   ae:SetCondition(aux.TRUE)
	   e:Reset()   
	end
end
function c10129002.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end