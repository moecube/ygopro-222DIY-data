--超时空战斗机-Axelay
function c13257318.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257318,4))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c13257318.eqcon)
	e1:SetTarget(c13257318.eqtg)
	e1:SetOperation(c13257318.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257318,4))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e1)
	e2:SetCondition(c13257318.eqcon1)
	e2:SetTarget(c13257318.eqtg1)
	e2:SetOperation(c13257318.eqop1)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c13257318.adcon)
	e3:SetValue(c13257318.atkval)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c13257318.adcon)
	e3:SetValue(c13257318.defval)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--Power Capsule
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257318,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c13257318.pccost)
	e4:SetTarget(c13257318.pctg)
	e4:SetOperation(c13257318.pcop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257318.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e4}
	c13257318[c]=eflist
	
end
function c13257318.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return c13257318.can_equip_monster(e:GetHandler())
end
function c13257318.filter(c)
	return c:GetFlagEffect(13257318)~=0
end
function c13257318.can_equip_monster(c)
	local g=c:GetEquipGroup():Filter(c13257318.filter,nil)
	return g:GetCount()==0
end
function c13257318.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return c and Duel.GetAttacker()==c and tc and tc:IsControler(1-tp) and tc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function c13257318.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(13257318,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c13257318.eqlimit)
			tc:RegisterEffect(e1)
			--substitute
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(c13257318.repval)
			tc:RegisterEffect(e2)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c13257318.eqfilter1(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257318.eqfilter2(c,e)
	return c:IsRelateToEffect(e)
end
function c13257318.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257318.eqfilter1,1,nil,1-tp) and c13257318.can_equip_monster(e:GetHandler())
end
function c13257318.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c and Duel.GetAttacker()==c and tc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function c13257318.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c13257318.eqfilter2,nil,e)
	if g:GetCount()>0 and tc:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(13257318,RESET_EVENT+0x1fe0000,0,0)
			e:GetLabelObject():SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c13257318.eqlimit)
			tc:RegisterEffect(e1)
			--substitute
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(c13257318.repval)
			tc:RegisterEffect(e2)
		end
	end
end
function c13257318.eqlimit(e,c)
	return e:GetOwner()==c
end
function c13257318.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c13257318.adcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	return ec and ec:GetFlagEffect(13257318)~=0
end
function c13257318.atkval(e,c)
	local ec=e:GetLabelObject():GetLabelObject()
	local atk=ec:GetTextAttack()
	if ec:IsFacedown() or bit.band(ec:GetOriginalType(),TYPE_MONSTER)==0 or atk<0 then
		return 0
	else
		return atk
	end
end
function c13257318.defval(e,c)
	local ec=e:GetLabelObject():GetLabelObject()
	local def=ec:GetTextDefense()
	if ec:IsFacedown() or bit.band(ec:GetOriginalType(),TYPE_MONSTER)==0 or def<0 then
		return 0
	else
		return def
	end
end
function c13257318.eqfilter(c,ec)
	return c:IsSetCard(0x3352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257318.tdfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c13257318.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local eq=e:GetHandler():GetEquipGroup()
	if chk==0 then return eq:IsExists(c13257318.tdfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=eq:FilterSelect(tp,c13257318.tdfilter,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c13257318.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257318.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	local t2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return (t1 or t2) and c:GetEquipCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c:GetEquipGroup(),1,0,0)
end
function c13257318.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257318.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and c:IsRelateToEffect(e) and c:IsFaceup()
	local t2=Duel.IsPlayerCanDraw(tp,1)
	if not (t1 or t2) then return end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257318,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257318,2),aux.Stringid(13257318,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257318,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257318,3))+1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257318.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif op==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c13257318.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257318,7))
end
