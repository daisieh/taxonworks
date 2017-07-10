const GetterNames = {
	GetAllRanks: 'getAllRanks',
	ActiveModalStatus: 'activeModalStatus',
	ActiveModalRelationship: 'activeModalRelationship',
	GetParent: 'getParent',
	GetRankClass: 'getRankClass',
	GetRankList: 'getRankList',
	GetRelationshipList: 'getRelationshipList',
	GetStatusList: 'getStatusList',
	GetTaxonStatusList: 'getTaxonStatusList',
	GetTaxonRelationshipList: 'getTaxonRelationshipList',
	GetTaxonAuthor: 'getTaxonAuthor',
	GetTaxonName: 'getTaxonName',
	GetTaxon: 'getTaxon',
	GetParentRankGroup: 'getParentRankGroup',
	GetTaxonYearPublication: 'getTaxonYearPublication',
	GetNomenclaturalCode: 'getNomenclaturalCode',
	GetSource: 'getSource'
};

const GetterFunctions = {
	[GetterNames.ActiveModalStatus]: require('./activeModalStatus'),
	[GetterNames.ActiveModalRelationship]: require('./activeModalRelationship'),
	[GetterNames.GetAllRanks]: require('./getAllRanks'),
	[GetterNames.GetParent]: require('./getParent'),
	[GetterNames.GetRankClass]: require('./getRankClass'),
	[GetterNames.GetRelationshipList]: require('./getRelationshipList'),
	[GetterNames.GetRankList]: require('./getRankList'),
	[GetterNames.GetStatusList]: require('./getStatusList'),
	[GetterNames.GetTaxonStatusList]: require('./getTaxonStatusList'),
	[GetterNames.GetTaxonRelationshipList]: require('./getTaxonRelationshipList'),
	[GetterNames.GetTaxonAuthor]: require('./getTaxonAuthor'),
	[GetterNames.GetTaxonName]: require('./getTaxonName'),
	[GetterNames.GetTaxon]: require('./getTaxon'),
	[GetterNames.GetParentRankGroup]: require('./getParentRankGroup'),
	[GetterNames.GetTaxonYearPublication]: require('./getTaxonYearPublication'),
	[GetterNames.GetNomenclaturalCode]: require('./getNomenclaturalCode'),
	[GetterNames.GetSource]: require('./getSource')
};

module.exports = {
	GetterNames,
	GetterFunctions
}