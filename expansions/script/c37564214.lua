--Sawawa-Seventh Doll
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564214
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
Senya.SawawaCommonEffect(c,2,true,false,false)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,m)
	e1:SetCondition(cm.seqcon)
	e1:SetCost(cm.seqcost)
	e1:SetOperation(cm.seqop)
	c:RegisterEffect(e1)
   --hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m-4000)
	e2:SetCondition(Senya.CheckNoExtra)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function cm.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) then
		local seq=c:GetSequence()
		if seq>4 then return end
		if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
			local flag=0xff
			if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag & ~(0x1 << seq-1) end
			if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag & ~(0x1 << seq+1) end
			Duel.Hint(HINT_SELECTMSG,tp,571)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
			local nseq=math.log(s,2)
			Duel.MoveSequence(c,nseq)
		end
	end
end


function cm.costfilter(c)
	return Senya.check_set_sawawa(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToDeck() end,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=e:GetHandler():GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToDeck() end,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end