--镇魂曲之门
function c10129013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--active
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10129013,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10129013.accost)
	e2:SetTarget(c10129013.actg)
	e2:SetOperation(c10129013.acop)
	c:RegisterEffect(e2) 
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10129013,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c10129013.drcost)
	e3:SetTarget(c10129013.drtg)
	e3:SetOperation(c10129013.drop)
	c:RegisterEffect(e3) 
	--race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetTarget(c10129013.racetg)
	e4:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e4) 
	--code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CHANGE_CODE)
	e5:SetValue(10129007)
	c:RegisterEffect(e5)
end
c10129013.card_code_list={10129007}
function c10129013.racetg(e,c)
	return c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL))
end
function c10129013.costfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and c:IsAbleToDeckOrExtraAsCost()
end
function c10129013.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10129013.costfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10129013.costfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10129013.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c10129013.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10129013.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c10129013.acfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if aux.IsCodeListed(c,10129007) and c:GetType()==TYPE_SPELL and c:IsAbleToGraveAsCost() then
		   if c:CheckActivateEffect(true,true,false)~=nil then return true end
		   local te=c:GetActivateEffect()
		   local con=te:GetCondition()
		   if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		   local tg=te:GetTarget()
		   if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	end
	return false
end
function c10129013.acop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te or not e:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10129013.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10129013.acfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10129013.acfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c10129013.acfilter(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end