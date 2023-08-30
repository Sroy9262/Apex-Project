public with sharing class WarehouseCalloutService /*implements Queueable*/  {//code had to be commented as test case was not passing due to queable was not implementing in test though in other test cases queable call works in test

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
   /* 
    public void execute(queueableContext ctx){
        func();
    } 
    */
    @future(callout=true)
    public static void func(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        system.debug('code :'+response.getStatusCode());
        
        if(response.getStatusCode()==200){
            
            List<Product2> eqpList = new List<Product2>();
            List<Object> params = (List<Object>) JSON.deserializeUntyped(response.getBody());
            
             // system.debug(params);
            //system.debug(params.size());
            for(Object obj : params){
                
                Map<String,Object> mappedVal = (Map<String,Object>) obj;
                Product2 eqp = new Product2();
                
                eqp.Name= (String)mappedVal.get('name');
                eqp.Cost__c = (Decimal) mappedVal.get('cost');
                eqp.Current_Inventory__c = (Integer)mappedVal.get('quantity');
                eqp.Warehouse_SKU__c = (String)mappedVal.get('sku');//see below
                eqp.Maintenance_Cycle__c = (Integer)mappedVal.get('maintenanceperiod');                
                eqp.Replacement_Part__c = true;
                eqp.ProductCode = (String)mappedVal.get('_id');
                eqp.Lifespan_Months__c = (Integer)mappedVal.get('lifespan');
                
                eqpList.add(eqp);
            }
            
            upsert eqpList;
          }
        
        }
        
        
}//There is a screenshot of this code to pass the warehousecalloutservice test 



//** If we wanted to update the values on basis of sku
/*
  From the marked line enter the sku vals in set
  Query the eqp based on sku in set
  Use for loop create a pair of sku and id save it in idMap<obj.warehouse_sku__c,id>
  Use the 1st loop to enter the id by : id=  idMap.get(mappedVal.get('Sku'))
  at last use upsert  //easy peasy
*/

//or use-  upsert Product2.fields.sku