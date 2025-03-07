--防卫火炮
function c13254117.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c13254117.lfilter),3,3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254117,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c13254117.spcon)
	e1:SetTarget(c13254117.sptg)
	e1:SetOperation(c13254117.spop)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c13254117.sumlimit)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c13254117.efilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13254117,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c13254117.descon)
	e5:SetCost(c13254117.descost)
	e5:SetTarget(c13254117.destg)
	e5:SetOperation(c13254117.desop)
	c:RegisterEffect(e5)
	
end
function c13254117.lfilter(c)
	return c:IsSetCard(0x356) and c:IsReleasable()
end
function c13254117.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(1) and c:IsSetCard(0x356) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c13254117.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c13254117.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c13254117.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13254117.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254117.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c13254117.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_LINK)
end
function c13254117.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13254117.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c13254117.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER)
end
function c13254117.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	local ct=lg:FilterCount(c13254117.filter,nil)
	if chk==0 then return c:GetFlagEffect(13254117)<(ct*2) end
	c:RegisterFlagEffect(13254117,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c13254117.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetTargetCard(Duel.GetAttacker())
end
function c13254117.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
