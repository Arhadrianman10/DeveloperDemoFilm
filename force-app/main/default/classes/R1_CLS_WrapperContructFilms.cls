public with sharing class R1_CLS_WrapperContructFilms {
    public class FilmsResponse{
        @AuraEnabled
        public List<WrapperFilm> Search {get;set;}
        @AuraEnabled
        public Integer totalResults {get;set;}
        public FilmsResponse(){
            Search = new List<WrapperFilm>();
        }

    }

    public class WrapperFilm{
        public WrapperFilm(){
        }
        @AuraEnabled
        public String Title {get;set;}
        @AuraEnabled
        public String Year {get;set;}
        @AuraEnabled
        public String imdbID {get;set;}
        @AuraEnabled
        public String Type {get;set;}
        @AuraEnabled
        public String Poster {get;set;}
    }

    public class FilmInfo{
        public FilmInfo(){
        }
        @AuraEnabled
        public String Title {get;set;}
        @AuraEnabled
        public String Year {get;set;}
        @AuraEnabled
        public String Runtime {get;set;}
        @AuraEnabled
        public String Genre {get;set;}
        @AuraEnabled
        public String Director {get;set;}
        @AuraEnabled
        public String Writer {get;set;}
        @AuraEnabled
        public String Actors {get;set;}
        @AuraEnabled
        public String Plot {get;set;}
        @AuraEnabled
        public String imdbRating {get;set;}
        @AuraEnabled
        public String Poster {get;set;}
    }

}