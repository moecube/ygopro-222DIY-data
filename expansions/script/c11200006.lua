--魔法与奇迹的代价 美树沙耶加
function c11200006.initial_effect(c)
	  --fusion material
	c:EnableReviveLimit()
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c11200006.fuscon)
	e0:SetOperation(c11200006.fusop)
	c:RegisterEffect(e0)
--[[ --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11200006.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11200006.spcon)
	e2:SetOperation(c11200006.spop)
	c:RegisterEffect(e2)]]
   --tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11200006,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11200013)
	e3:SetCost(c11200006.cost)
	e3:SetCondition(c11200006.con)
	e3:SetTarget(c11200006.tg)
	e3:SetOperation(c11200006.op)
	c:RegisterEffect(e3)
	--sp
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,11200006)
	e4:SetTarget(c11200006.retg)
	e4:SetOperation(c11200006.reop)
	c:RegisterEffect(e4)
end
function c11200006.ffilter(c,fc)
	return c11200006.ffilter1(c,fc) or c11200006.ffilter2(c,fc) 
end
function c11200006.ffilter1(c,fc)
	return c:IsFusionSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc) 
end
function c11200006.ffilter2(c,fc)
	return c:IsFusionSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)  
end
function c11200006.spfilter1(c,tp,mg,fc)
	  return mg:IsExists(c11200006.spfilter2,1,c,tp,c,fc) 
end
function c11200006.spfilter2(c,tp,mc,fc)
	return ((c11200006.ffilter1(c,fc) and c11200006.ffilter2(mc,fc))
		or (c11200006.ffilter2(c,fc) and c11200006.ffilter1(mc,fc)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c11200006.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
   local mg=g:Filter(c11200006.ffilter,nil,c)
	local mg1=g:Filter(c11200006.ffilter1,nil,c)
	local mg2=g:Filter(c11200006.ffilter2,nil,c)
   local tg=Duel.GetMatchingGroup(c11200006.ffilter,tp,LOCATION_DECK,0,nil,c)
	local tg1=Duel.GetMatchingGroup(c11200006.ffilter1,tp,LOCATION_DECK,0,nil,c)
	 local tg2=Duel.GetMatchingGroup(c11200006.ffilter2,tp,LOCATION_DECK,0,nil,c)
	if gc then
		if not mg:IsContains(gc) then return false end
	   if Duel.GetFlagEffect(tp,11200002)~=0 then
		return mg:IsExists(c11200006.spfilter2,1,gc,tp,gc,c) or tg:IsExists(c11200006.spfilter2,1,gc,tp,gc,c)
		else
		return mg:IsExists(c11200006.spfilter2,gc,tp,gc,c) 
end
end
	if Duel.GetFlagEffect(tp,11200002)~=0 and mg1:GetCount()==0 and
	mg2:GetCount()~=0  then
	 return tg1:IsExists(c11200006.spfilter1,1,nil,tp,mg2,c) 
   elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()==0 and
	mg1:GetCount()~=0  then
	return tg2:IsExists(c11200006.spfilter1,1,nil,tp,mg1,c)
	 elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg:GetCount()==1 then
	 return tg:IsExists(c11200006.spfilter1,1,nil,tp,mg,c) 
	else
	return mg:IsExists(c11200006.spfilter1,1,nil,tp,mg,c) 
end
end
function c11200006.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	  local c=e:GetHandler()
	local mg=eg:Filter(c11200006.ffilter,nil,c)
	local mg1=eg:Filter(c11200006.ffilter1,nil,c)
	local mg2=eg:Filter(c11200006.ffilter2,nil,c)
	local tg=Duel.GetMatchingGroup(c11200006.ffilter,tp,LOCATION_DECK,0,nil,c)
	local tg1=Duel.GetMatchingGroup(c11200006.ffilter1,tp,LOCATION_DECK,0,nil,c)
	 local tg2=Duel.GetMatchingGroup(c11200006.ffilter2,tp,LOCATION_DECK,0,nil,c)
	local g=nil
	local sg
	if gc then
		g=Group.FromCards(gc)
		mg:RemoveCard(gc)
	else
	   if Duel.GetFlagEffect(tp,11200002)~=0 and mg1:GetCount()~=0 and
	mg2:GetCount()~=0 and tg:GetCount()>0 and mg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(11200004,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg:FilterSelect(tp,c11200006.spfilter1,1,1,nil,tp,mg,c)
		Duel.ResetFlagEffect(tp,11200002)
		elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()==0 and mg1:GetCount()~=0 and tg2:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg2:FilterSelect(tp,c11200006.spfilter1,1,1,nil,tp,mg1,c)
		Duel.ResetFlagEffect(tp,11200002)
	   elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()~=0 and mg1:GetCount()==0 and tg1:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg1:FilterSelect(tp,c11200006.spfilter1,1,1,nil,tp,mg2,c)
		Duel.ResetFlagEffect(tp,11200002)
		 elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg:GetCount()==1  then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg:FilterSelect(tp,c11200006.spfilter1,1,1,nil,tp,mg,c)
		Duel.ResetFlagEffect(tp,11200002)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=mg:FilterSelect(tp,c11200006.spfilter1,1,1,nil,tp,mg,c)
		mg:Sub(g)
end
	end
	  if Duel.GetFlagEffect(tp,11200002)~=0 and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11200004,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		sg=tg:FilterSelect(tp,c11200006.spfilter2,1,1,nil,tp,g:GetFirst(),c)
		Duel.ResetFlagEffect(tp,11200002)
		 else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		sg=mg:FilterSelect(tp,c11200006.spfilter2,1,1,nil,tp,g:GetFirst(),c)
end
	g:Merge(sg)
	Duel.SetFusionMaterial(g)
end
function c11200006.rfilter(c,fc)
	return (c:IsFusionSetCard(0x134) or c:IsRace(RACE_SPELLCASTER)) and c:IsCanBeFusionMaterial(fc) 
end
function c11200006.rfilter1(c,tp,g)
	return g:IsExists(c11200006.spfilter2,1,c,tp,c)
end
function c11200006.rfilter2(c,tp,mc)
	return ((c:IsFusionSetCard(0x134) and mc:IsRace(RACE_SPELLCASTER)) or
	(mc:IsFusionSetCard(0x134) and c:IsRace(RACE_SPELLCASTER))) and  Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c11200006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	 local rg=Duel.GetReleaseGroup(tp):Filter(c11200006.rfilter,nil,c)
	return rg:IsExists(c11200006.rfilter1,1,nil,tp,rg)
end
function c11200006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c11200006.rfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=rg:FilterSelect(tp,c11200006.rfilter1,1,1,nil,tp,rg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=rg:FilterSelect(tp,c11200006.rfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c11200006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200006.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200006.tgfilter,1,nil,tp)
end
function c11200006.tgfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetOwner()==tp
end
function c11200006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function c11200006.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if  Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)>0 then
	Duel.BreakEffect()
	--Atk
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e1:SetValue(900)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Def
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(900)
	Duel.RegisterEffect(e2,tp)
end
end
function c11200006.refilter(c)
	return  c:IsReleasable() and  c:IsType(TYPE_MONSTER)
end
function c11200006.refilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsReleasable()
end
function c11200006.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local g=Duel.GetMatchingGroup(c11200006.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)	
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
	 and g:GetCount()>1 and g:IsExists(c11200006.refilter2,1,nil)
	 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true)
end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c11200006.reop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c11200006.refilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c11200006.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,g1:GetFirst())
	g2:Merge(g1)
   if g2:GetCount()==2 and Duel.Release(g2,REASON_EFFECT)==2 and  e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,true,POS_FACEUP) then
	e:GetHandler():CompleteProcedure()
end
end