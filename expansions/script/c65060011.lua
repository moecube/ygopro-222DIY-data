--机械色 西洋镜
function c65060011.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x6da3),2,99)
	--kaleidoscope
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c65060011.sptg)
	e1:SetOperation(c65060011.spop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65060011)
	e2:SetCondition(c65060011.effcon)
	e2:SetTarget(c65060011.efftg)
	e2:SetOperation(c65060011.effop)
	c:RegisterEffect(e2)
end

function c65060011.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end

function c65060011.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetMutualLinkedGroupCount()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c65060011.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

function c65060011.spfil(c,e,tp)
   return c:IsCode(65060011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c65060011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c65060011.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	local mt=Duel.GetMatchingGroupCount(c65060011.spfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if mt>ft then mt=ft end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then mt=1 end
	local g=Duel.SelectMatchingCard(tp,c65060011.spfil,tp,LOCATION_EXTRA,0,mt,mt,nil,e,tp)
	if mt>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.BreakEffect()
	local cg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil)
	Duel.ConfirmCards(1-tp,cg)
	local gg=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EXTRA,0,nil,65060011)
	if gg>0 then
		local tgg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,nil,65060011)
		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
end

