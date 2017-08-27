--扭曲飞球·反常之饥
function c13254104.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c13254104.ffilter1,aux.FilterBoolFunction(c13254104.ffilter2,c),2,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254104.sprcon)
	e2:SetOperation(c13254104.sprop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetValue(function (e,re,rp)
	return rp==e:GetHandlerPlayer()
	end)
	c:RegisterEffect(e3)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e5)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e14)
	local e15=e13:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e15)
	
end
function c13254104.ffilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE)
end
function c13254104.ffilter2(c,fc)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsControler(fc:GetControler())
end
function c13254104.cfilter(c,tp)
	return (c:IsFusionAttribute(ATTRIBUTE_FIRE) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsControler(tp)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c13254104.fcheck(c,sg,tp)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and c:IsFaceup() and sg:IsExists(c13254104.fcheck2,2,c,tp)
end
function c13254104.fcheck2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsControler(tp)
end
function c13254104.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c13254104.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254104.fcheck,1,nil,sg,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c13254104.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254104.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254104.fselect,1,nil,tp,mg,sg)
end
function c13254104.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254104.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,c13254104.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_COST)
end
