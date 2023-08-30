public with sharing class MaintenanceRequestHelper {//My Code Modified by GPT

    public static void updateWorkOrders(List<Case> caseList, Map<Id, Case> inNewMap) {
        // TODO: Complete the method to update workorders

        List<Case> addCaseList = new List<Case>();
        List<Case> newCaseList = [
            SELECT Id, (SELECT Equipment__c FROM Equipment_Maintenance_Items__r)
            FROM Case
            WHERE Id IN :inNewMap.keySet()
        ];

        // Create a set to store the unique Equipment IDs
        Set<Id> equipmentIds = new Set<Id>();
        for (Case caseObj : newCaseList) {
            for (Equipment_Maintenance_Item__c obj : caseObj.Equipment_Maintenance_Items__r) {
                equipmentIds.add(obj.Equipment__c);
            }
        }

        // Map to store the Maintenance Cycle values for Equipment
        Map<Id, Decimal> maintenanceCycleMap = new Map<Id, Decimal>();
        for (Product2 product : [
            SELECT Id, Maintenance_Cycle__c
            FROM Product2
            WHERE Id IN :equipmentIds
        ]) {
            maintenanceCycleMap.put(product.Id, product.Maintenance_Cycle__c);
        }

        Map<Id, Decimal> mapval = new Map<Id, Decimal>(); // Declaration of mapval variable

        for (Case caseObj : newCaseList) {
            Decimal tempVal = null;

            for (Equipment_Maintenance_Item__c obj : caseObj.Equipment_Maintenance_Items__r) {
                Decimal val = maintenanceCycleMap.get(obj.Equipment__c);

                if (tempVal == null) {
                    tempVal = val;
                }
                if (tempVal != null && val <= tempVal) {
                    mapval.put(caseObj.id, val);
                    tempVal = val;
                }
            }
        }

        for (Case caseObj : caseList) {
            if ((caseObj.Type == 'Repair' || caseObj.Type == 'Routine Maintenance') && inNewMap.get(caseObj.id).Status == 'Closed' && mapval.get(caseObj.id) != null) {
                Case caseObj1 = new Case();
                caseObj1.Product__c = caseObj.Product__c;
                caseObj1.Vehicle__c = caseObj.Vehicle__c;
                caseObj1.Type = 'Routine Maintenance';
                caseObj1.Subject = 'follow up to previous maintenance having id: ' + caseObj.Id;
                caseObj1.Date_Reported__c = System.today();
                caseObj1.Status = 'New';
                caseObj1.Priority = 'Low';
                caseObj1.Origin = 'Web';
                caseObj1.ContactId = caseObj.ContactId;
                caseObj1.ParentId = caseObj.id;
                caseObj1.ProductId = caseObj.ProductId;
                caseObj1.Date_Due__c = System.today().addDays((Integer) mapval.get(caseObj.id));

                addCaseList.add(caseObj1);
            }
        }

        if (!addCaseList.isEmpty()) {
            insert addCaseList;
        }

        List<Equipment_Maintenance_Item__c> addItemList = new List<Equipment_Maintenance_Item__c>();
        for (Case caseObj : addCaseList) {
            for (Case caseObj1 : newCaseList) {
                if (caseObj.ParentId == caseObj1.id) {
                    for (Equipment_Maintenance_Item__c eqObj : caseObj1.Equipment_Maintenance_Items__r) {
                        Equipment_Maintenance_Item__c eqObj1 = eqObj.clone();
                        eqObj1.Maintenance_Request__c = caseObj.id;
                        addItemList.add(eqObj1);
                    }
                }
            }
        }

        if (!addItemList.isEmpty()) {
            insert addItemList;
        }
    }
}

/*public with sharing class MaintenanceRequestHelper {//this code works but it exceeds the SOQL limit
    
    public static void updateWorkOrders(List<Case>caseList,Map<Id,Case> inNewMap) {
        // TODO: Complete the method to update workorders
        
        List<Case> addCaseList = new List<Case>();
        List<Case> newCaseList = [Select Id, (Select Equipment__c From Equipment_Maintenance_Items__r) From Case Where Id IN :inNewMap.keySet()];
        Map<Id,Decimal> mapval = new Map<Id,Decimal>();
        for(Case caseobj : newCaseList){
            Decimal tempVal = null;
            
            for(Equipment_Maintenance_Item__c obj : caseObj.Equipment_Maintenance_Items__r){
                                  
                Decimal val = [Select Maintenance_Cycle__c From Product2 Where Id = :obj.Equipment__c].Maintenance_Cycle__c;
                
                if(tempVal == null){
                    tempVal = val;
                }
                if(tempVal != null && val <= tempVal){
                    mapval.put(caseObj.id,val);
                    tempVal = val;
                }
                
            }
            
        }
        
        for(Case caseObj : caseList){
            
            if((caseObj.Type=='Repair'||caseObj.Type=='Routine Maintenance') && inNewMap.get(caseObj.id).Status == 'Closed' && mapval.get(caseObj.id)!=null){
                
                Case caseObj1 = new Case();
                caseObj1.Product__c = caseObj.Product__c;
                caseObj1.Vehicle__c = caseObj.Vehicle__c;
                caseObj1.Type = 'Routine Maintenance';
                caseObj1.Subject = 'follow up to previous maintenance having id: '+caseObj.Id;
                caseObj1.Date_Reported__c = system.today();
                caseObj1.Status = 'New';
                caseObj1.Priority = 'Low';
                caseObj1.Origin = 'Web';
                caseObj1.ContactId = caseObj.ContactId;
                caseObj1.ParentId = caseObj.id;
                caseObj1.ProductId = caseObj.ProductId;
                caseObj1.Date_Due__c = system.today().addDays((Integer)mapval.get(caseObj.id));
                
                addCaseList.add(caseObj1);
                
            }
            
        }
        
        if(!addCaseList.isEmpty()){
           
                insert addCaseList;
                
            }
        
        List<Equipment_Maintenance_Item__c> addItemList = new List<Equipment_Maintenance_Item__c>();
        for(Case caseObj : addCaseList){
            
            for(Case caseObj1 : newCaseList){
                
                if(caseObj.ParentId == caseObj1.id){
                    
                    for(Equipment_Maintenance_Item__c eqObj: caseObj1.Equipment_Maintenance_Items__r){
                      Equipment_Maintenance_Item__c eqObj1 = eqObj.clone();
                        eqObj1.Maintenance_Request__c = caseObj.id;
                        addItemList.add(eqObj1);
                    }
                    
                }
                
            }
            
        }
        
        if(!addItemList.isEmpty()){
                
                insert addItemList;
            }
           
        }
}        
*/