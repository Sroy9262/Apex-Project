@isTest
public class testUtility_MaintenanceRequestHelper {

    public static List<Case> mockVal(){
        
        Vehicle__c vehObj = new Vehicle__c(Name = 'Test Vehicle');
        insert vehObj;
        
        Contact conObj = new Contact(FirstName = 'Sid', LastName = 'Roy');
        insert conObj;
        
    List<Product2> equipmentList = new List<Product2>();
    for (Integer i = 1; i <= 10; i++) {
        equipmentList.add(new Product2(Name = 'Test'+i , ProductCode = 'GC104'+i ,Maintenance_Cycle__c =(Decimal) 20+i, replacement_part__c = true));
    }
    insert equipmentList;
        
       List<Case> caseList = new List<Case>();
       for (Integer i = 1; i <= 400; i++) {
         Case caseObj1 = new Case();
            caseObj1.Vehicle__c = vehObj.Id;
            caseObj1.Date_Reported__c = System.today();
            caseObj1.Status = 'New';
            caseObj1.Priority = 'Low';
            caseObj1.ContactId = conObj.Id;
            //caseObj1.ProductId = proObj.Id;
            caseObj1.Date_Due__c = System.today().addDays(15);

    if (i <= 150) {
        caseObj1.Type = 'Routine Maintenance';
        caseObj1.Origin = 'Web';
    } else if (i > 150 && i <= 300) {
        caseObj1.Type = 'Repair';
        caseObj1.Origin = 'Phone';
    } else if (i > 300) {
        caseObj1.Type = 'Other';
        caseObj1.Origin = 'Email';
    }

    caseList.add(caseObj1);
}

insert caseList;

List<Equipment_Maintenance_Item__c> eqpList = new List<Equipment_Maintenance_Item__c>();
for (Case obj : caseList) {
   for (Product2 equipment : equipmentList) {
            eqpList.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = obj.Id, Equipment__c = equipment.Id));
        }
}
insert eqpList;
        
return caseList;

    }
    
}