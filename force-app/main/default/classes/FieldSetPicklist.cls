/**
 * @description - This class handles the picklist field within a fieldset such as retrieving the picklist values or metadata 
 * associated with those fields
 */ 
public class FieldSetPicklist extends VisualEditor.DynamicPickList {
    /**
     * @description sObjectApiName - Accepts the String object api name
     */ 
    private String sObjectApiName;
	
    /**
     * @description FieldSetPicklist - This interacts with picklist fields, takes the api name
     */ 
    public FieldSetPicklist(VisualEditor.DesignTimePageContext context) {
       this.sObjectApiName = context.entityName;
    }
    
    /**
     * @description getDefaultValue - This method helps in managing the default values
     * @return - Returns the default value
     */ 
    public override VisualEditor.DataRow getDefaultValue(){
        return getValues().getDataRows()[0];
    }
	
    /** 
     * @description getValues - This methods helps to get the values of the fields
     * @return values - Return the values 
     */ 
    public override VisualEditor.DynamicPickListRows getValues() {
        Map<String, FieldSet> fieldSetMap = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().fieldSets.getMap();
        VisualEditor.DynamicPickListRows values = new VisualEditor.DynamicPickListRows();

        for (Schema.FieldSet fs : fieldSetMap.values()) {
            values.addRow(new VisualEditor.DataRow(
                fs.getLabel(), getAPIName(fs.getNameSpace(), fs.getName())));
        }
        
        return values;
    }
	/** 
	 * @description getAPIName - This method is used to get the api name 
	 * @param nameSpace - Accepts the string namespace
	 * @param name - Accepts the string name
	 * @return name - Returns the name
	 */ 
    private String getAPIName(String nameSpace, String name) {
        if(nameSpace != null && nameSpace.length() > 0) {
            return nameSpace + '__' + name;
        } else {
            return name;
        }
    }
}