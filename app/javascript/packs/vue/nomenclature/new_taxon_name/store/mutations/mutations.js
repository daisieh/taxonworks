const MutationNames = {
	AddTaxonStatus: 'addTaxonStatus',
	AddTaxonRelationship: 'addTaxonRelationship',
	RemoveTaxonStatus: 'removeTaxonStatus',
	RemoveTaxonRelationship: 'removeTaxonRelationship',
	SetModalStatus: 'setModalStatus',
	SetModalRelationship: 'setModalRelationship',
	SetAllRanks: 'setAllRanks',
	SetParent: 'setParent',
	SetParentId: 'setParentId',
	SetRankClass: 'setRankClass',
	SetRankList: 'setRankList',
	SetParentRankGroup: 'setParentRankGroup',
	SetRelationshipList: 'setRelationshipList',
	SetStatusList: 'setStatusList',
	SetTaxonStatusList: 'setTaxonStatusList',
	SetTaxonAuthor: 'setTaxonAuthor',
	SetTaxonName: 'setTaxonName',
	SetTaxonId: 'setTaxonId',
	SetTaxon: 'setTaxon',
	SetSource: 'setSource',
	SetTaxonYearPublication: 'setTaxonYearPublication',
	SetNomenclaturalCode: 'setNomenclaturalCode'
};

const MutationFunctions = {
	[MutationNames.AddTaxonStatus]: require('./addTaxonStatus'),
	[MutationNames.AddTaxonRelationship]: require('./addTaxonRelationship'),
	[MutationNames.RemoveTaxonStatus]: require('./removeTaxonStatus'),
	[MutationNames.RemoveTaxonRelationship]: require('./removeTaxonRelationship'),
	[MutationNames.SetModalStatus]: require('./setModalStatus'),
	[MutationNames.SetModalRelationship]: require('./setModalRelationship'),
	[MutationNames.SetAllRanks]: require('./setAllRanks'),
	[MutationNames.SetParent]: require('./setParent'),
	[MutationNames.SetParentId]: require('./setParentId'),
	[MutationNames.SetRelationshipList]: require('./setRelationshipList'),
	[MutationNames.SetRankClass]: require('./setRankClass'),
	[MutationNames.SetRankList]: require('./setRankList'),
	[MutationNames.SetStatusList]: require('./setStatusList'),
	[MutationNames.SetTaxonStatusList]: require('./setTaxonStatusList'),
	[MutationNames.SetTaxonAuthor]: require('./setTaxonAuthor'),
	[MutationNames.SetTaxonName]: require('./setTaxonName'),
	[MutationNames.SetTaxonId]: require('./setTaxonId'),
	[MutationNames.SetTaxon]: require('./setTaxon'),
	[MutationNames.SetSource]: require('./setSource'),
	[MutationNames.SetParentRankGroup]: require('./setParentRankGroup'),
	[MutationNames.SetTaxonYearPublication]: require('./setTaxonYearPublication'),
	[MutationNames.SetNomenclaturalCode]: require('./setNomenclaturalCode'),
};

module.exports = {
	MutationNames,
	MutationFunctions
};