--流雾麟 暴雨之鞉
function c21400047.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	c:EnableReviveLimit()
	--cannot special summon
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetCode(EFFECT_SPSUMMON_CONDITION)
	e00:SetValue(aux.ritlimit)
	c:RegisterEffect(e00)   
	
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21400047,0))
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCost(c21400047.rlcost)
	e0:SetTarget(c21400047.rltarget)
	e0:SetOperation(c21400047.rloperation)
	c:RegisterEffect(e0)

	--tian shi de shi she
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400047,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21400047)
	e1:SetCost(c21400047.thcost)
	e1:SetTarget(c21400047.thtg)
	e1:SetOperation(c21400047.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400047,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(c21400047.dtg)
	e2:SetOperation(c21400047.dop)
	c:RegisterEffect(e2)

end

function c21400047.mat_filter(c)
	return not c:IsLocation(LOCATION_GRAVE)
end

function c21400047.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c21400047.rltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c21400047.rloperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c21400047.jffilter(c)
	return c:IsReleasable() and ( c:GetSequence()==0 or c:GetSequence()==4 )
end

function c21400047.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) 
			then return Duel.IsExistingMatchingCard(c21400047.jffilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) 
		else return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	end

	local g
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) 
		then g=Duel.SelectMatchingCard(tp,c21400047.jffilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	else 
		g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
	end
	
	Duel.Release(g,REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c21400047.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function c21400047.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end

function c21400047.dfilter(c)
	return c:IsSetCard(0xc20) and c:IsAbleToHand()
end
function c21400047.dwfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()<=6 and c:IsAbleToRemove()
end
function c21400047.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400047.dfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c21400047.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c21400047.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400047.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c21400047.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end






