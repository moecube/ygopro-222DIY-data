--Wait for Spring
local m=37564529
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	--Senya.nntr(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.fit_monster={37564504,37564526,37564552}
function cm.filter(c,e,tp,m1,m2)
	local ec=e:GetHandler()
	if not ec.fit_monster then return false end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local cd1=c:GetOriginalCode()
	local cd2=c:GetCode()
	local check=false
	for i,cd in pairs(ec.fit_monster) do
		if cd==cd1 or cd==cd2 then check=true end
	end
	if not check then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	return Senya.CheckRitualMaterial(c,mg,tp,c:GetLevel(),nil,true)
end
function cm.mfilter(c)
	return c:IsCode(37564765) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=Senya.SelectRitualMaterial(tc,mg,tp,tc:GetLevel(),nil,true)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			return rp==tp and re:IsActiveType(TYPE_TRAP) and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc.Senya_desc_with_nanahira and rc:IsCanTurnSet() and rc:IsRelateToEffect(re) and e:GetHandler():GetFlagEffect(m)==0 
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if not Duel.SelectYesNo(tp,m*16+1) then return end
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
			local rc=re:GetHandler()
			rc:CancelToGrave()
			Duel.ChangePosition(rc,POS_FACEDOWN)
			Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(m-4000,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,m*16)
	end
end