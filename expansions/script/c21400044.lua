--流流雾麟 灰霾之敔
function c21400044.initial_effect(c)
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
	e0:SetDescription(aux.Stringid(21400044,0))
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCost(c21400044.rlcost)
	e0:SetTarget(c21400044.rltarget)
	e0:SetOperation(c21400044.rloperation)
	c:RegisterEffect(e0)

	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400044,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21400044.sccon)
	e2:SetTarget(c21400044.sctarg)
	e2:SetOperation(c21400044.scop)
	c:RegisterEffect(e2)

	--break
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21400044,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c21400044.jftg)
	e3:SetOperation(c21400044.jfop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c21400044.dtcon)
	c:RegisterEffect(e4)

end

function c21400044.dtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp
end

function c21400044.mat_filter(c)
	return not c:IsLocation(LOCATION_GRAVE)
end

function c21400044.jffl(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_WYRM) and not c:IsForbidden()
end
function c21400044.jflmt(e,ep,tp)
	return tp==ep 
end
function c21400044.jftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c21400044.jflmt)
end
function c21400044.jfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local pp=tc:GetControler()
	if tc:IsRelateToEffect(e) then
		local cntrn=Duel.Destroy(tc,nil,REASON_EFFECT)
		if cntrn<=0 then return end
		if(Duel.IsExistingTarget(c21400044.jffl,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) and ( Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(pp,LOCATION_PZONE,1) ) and Duel.SelectYesNo(pp,aux.Stringid(21400044,3))) then
			local sg=Duel.SelectMatchingCard(tp,c21400044.jffl,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
			local sc=sg:GetFirst()
			if sc then Duel.MoveToField(sc,tp,pp,LOCATION_SZONE,POS_FACEUP,true) end
		end
	end
end


function c21400044.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c21400044.rltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c21400044.rloperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c21400044.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function c21400044.mtfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function c21400044.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsExistingTarget(c21400044.mtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
		--and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,mg) end
	c:RegisterFlagEffect(21400044,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

--function c21400044.ssfl(c)

function c21400044.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400044.mtilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local cntrn=Duel.SendtoHand(g,nil,REASON_EFFECT)
		if cntrn<=0 then return end
		local c=e:GetHandler()
		if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
		if not Duel.SelectYesNo(tp,aux.Stringid(21400044,4)) then return end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_HAND_SYNCHRO)
		e3:SetTargetRange(0,1)
		e:GetHandler():RegisterEffect(e3,true)
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
		Effect.Reset(e3)
	end
end



