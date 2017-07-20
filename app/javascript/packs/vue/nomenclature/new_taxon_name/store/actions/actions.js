const ActionNames = {
	SetParentAndRanks: 'setParentAndRanks',
	AddTaxonStatus: 'addTaxonStatus',
	AddTaxonRelationship: 'addTaxonRelationship',
	RemoveTaxonStatus: 'removeTaxonStatus',
	RemoveTaxonRelationship: 'removeTaxonRelationship',
	LoadSoftValidation: 'loadSoftValidation',
	ChangeTaxonSource: 'changeTaxonSource',
	RemoveSource: 'removeSource',
};

const ActionFunctions = {
	[ActionNames.LoadSoftValidation]: require('./loadSoftValidation'),
	[ActionNames.SetParentAndRanks]: require('./setParentAndRanks'),
	[ActionNames.AddTaxonStatus]: require('./addTaxonStatus'),
	[ActionNames.AddTaxonRelationship]: require('./addTaxonRelationship'),
	[ActionNames.RemoveTaxonStatus]: require('./removeTaxonStatus'),
	[ActionNames.RemoveTaxonRelationship]: require('./removeTaxonRelationship'),
	[ActionNames.RemoveSource]: require('./removeSource'),
	[ActionNames.ChangeTaxonSource]: require('./changeTaxonSource'),
};

module.exports = {
	ActionNames,
	ActionFunctions
}