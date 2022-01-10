public with sharing class R1_CLS_Callout {


    public HTTPRequest request;
    public HTTPResponse response;


    public Object callService(Object body,String endpoint, Map<String,String> headers, String method, Integer timeout){
        HttpRequest request = initializeRequest(endpoint,headers,method,timeout);
        if(body!=null){
            request.setBody((String)body);
        }
        return handleResponse(sendRequest(request));
    }

    public HttpRequest initializeRequest(String endpoint, Map<String,String> headers, String method, Integer timeout){
        HttpRequest req = new HttpRequest();  
        req.setEndpoint(endpoint);
        req.setMethod(method);
        for(String header : headers.keySet()){
            req.setHeader(header, headers.get(header));
        }
        req.setTimeout(timeout);
        return req;
    }


    public virtual Object handleResponse(HTTPResponse res){
        this.response = res;
        // Metodo para gestionar el Codigo de estado de la llamada, en este caso de peliculas supongo que será siempre 200
        if(res != null){
            return res.getBody();
        }else{
            return null;
        }
        
    }


    public HttpResponse sendRequest(HttpRequest req){
        Http http = new Http();
        System.debug('Method: '+req.getMethod());
        System.debug('Endpoint: '+req.getEndpoint());
        try{
            return http.send(req);
        }
        catch(Exception e){
            System.debug('Exception: '+e);
            return null;
        }
        
    }

    public static ServiceDefinition__mdt checkWSMdt(String serviceName){
        ServiceDefinition__mdt[] serviceConfig=new List<ServiceDefinition__mdt>(
            [SELECT API_Key__c,Base_URL__c,Service__c,
                Method__c,Timeout__c
            FROM ServiceDefinition__mdt 
            WHERE DeveloperName = :serviceName
            AND Active__c=true limit 1]
        );
        if(!serviceConfig.isEmpty()){
            return serviceConfig[0];
        }
        throw new CalloutException('El servicio indicado no existe o esta inactivo');
    }

    
}