public with sharing class R1_CTR_CLS_SearchFilm {
    @AuraEnabled(Cacheable = true)
    public static R1_CLS_WrapperContructFilms.FilmsResponse retrieveFilms(String strFilmsName, String page) {

        Integer numer = Integer.valueOf(page);
        ServiceDefinition__mdt config=R1_CLS_Callout.checkWSMdt('Omdb');
        String params = config.Base_URL__c+config.Service__c+getParams(config,strFilmsName,numer);
        
        R1_CLS_Callout handler=new R1_CLS_Callout();
        Object result = handler.callService
        (
            null,
            params,
            new Map<String,String>(),
            config.Method__c,
            Integer.valueOf(config.Timeout__c)
        );
        R1_CLS_WrapperContructFilms.FilmsResponse parsedResult = new R1_CLS_WrapperContructFilms.FilmsResponse();
        if(result!=null){
            parsedResult = (R1_CLS_WrapperContructFilms.FilmsResponse) JSON.deserialize(String.valueOf(result), R1_CLS_WrapperContructFilms.FilmsResponse.class);
        }
        if(parsedResult==null || parsedResult.Search == null || parsedResult.Search.size() == 0){
            throw new AuraHandledException('No existe ningún registro para los datos introducidos');
        }

        return parsedResult; 
    }
    @AuraEnabled(Cacheable = true)
    public static R1_CLS_WrapperContructFilms.FilmInfo infoFilm(String strFilmId) {

        ServiceDefinition__mdt config=R1_CLS_Callout.checkWSMdt('Omdb');
        String params = config.Base_URL__c+config.Service__c+getParams(config,strFilmId);
        
        R1_CLS_Callout handler=new R1_CLS_Callout();
        Object result = handler.callService
        (
            null,
            params,
            new Map<String,String>(),
            config.Method__c,
            Integer.valueOf(config.Timeout__c)
        );
        R1_CLS_WrapperContructFilms.FilmInfo parsedResult = new R1_CLS_WrapperContructFilms.FilmInfo();
        if(result!=null){
            parsedResult = (R1_CLS_WrapperContructFilms.FilmInfo) JSON.deserialize(String.valueOf(result), R1_CLS_WrapperContructFilms.FilmInfo.class);
        }
        if(parsedResult==null){
            throw new AuraHandledException('No existe ningún registro para los datos introducidos');
        }

        return parsedResult; 
    }


    public static String getParams(ServiceDefinition__mdt config, String strFilmsName,Integer page){
        String params = '';
        strFilmsName=strFilmsName.replace(' ','+');

        if(config != null){
            params= String.isNotBlank(config.API_Key__c) ? 'apikey='+config.API_Key__c : '';
        }
        params= String.isNotBlank(strFilmsName) ? params+'&s='+strFilmsName : params;
        params= page!=null ? params+'&page='+page : params;


        return params;
    }

    public static String getParams(ServiceDefinition__mdt config, String strFilmId){
        String params = '';
        strFilmId=strFilmId.replace(' ','+');

        if(config != null){
            params= String.isNotBlank(config.API_Key__c) ? 'plot=full&apikey='+config.API_Key__c : '';
        }
        params= String.isNotBlank(strFilmId) ? params+'&i='+strFilmId : params;


        return params;
    }


}