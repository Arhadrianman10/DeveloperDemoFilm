import { LightningElement } from 'lwc';
import searchFilms from '@salesforce/apex/R1_CTR_CLS_SearchFilm.retrieveFilms';
import infoFilm from '@salesforce/apex/R1_CTR_CLS_SearchFilm.infoFilm';
import {loadStyle} from 'lightning/platformResourceLoader'
import style from '@salesforce/resourceUrl/ResourcePoster';


const actions = [
    { label: 'Mostrar detalles', name: 'show_details' },
];


const COLUMNS = [
    { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'left' } },
    {label:'Poster', fieldName:'Poster', type:'image', initialWidth: 175, cellAttributes:{
        class:{fieldName:'StylePoster'}
    }},
    {label:'Titulo', fieldName:'Title', type: 'Text'},
    {label:'Año', fieldName:'Year', type:'Text'},
    {label:'Tipo', fieldName:'Type', type:'text'},
    {label:'ID', fieldName:'imdbID', type:'text',initialWidth: 80,},
]




export default class FilmSearchInLWC extends LightningElement {
    film='';
    rating='';
    year='';
    runtime='';
    genre='';
    director='';
    writters='';
    actors='';
    plot='';
    urlimg='';
    numberResult = 0;
    searchData;
    errorMsg = '';
    strSearchAccName = '';
    page = 1;
    totalPage = 1;
    disableprev = false;
    disablenext = false;
    isModalOpen = false;

    tableData;
    columns = COLUMNS;    

    closeModal() {
        this.isModalOpen = false;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row
        console.log(action);
        console.log(row.imdbID);

        infoFilm({strFilmId : row.imdbID})
        .then(result => {

            this.film = result.Title;
            this.year = result.Year;
            this.runtime = result.Runtime;
            this.genre = result.Genre;
            this.director = result.Director;
            this.writters = result.Writer;
            this.actors = result.Actors;
            this.plot = result.Plot;
            this.rating = result.imdbRating+'/10';
            this.urlimg = result.Poster;

            this.isModalOpen = true;
        })
        .catch(error => {   
            this.searchData = undefined;
            if(error) {
                if (Array.isArray(error.body)) {
                    this.errorMsg = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.errorMsg = error.body.message;
                }
            }
        }) 

    }
    
    handleFilmName(event) {
        this.errorMsg = '';
        this.strSearchAccName = event.currentTarget.value;
    }

    keyCheck(event){
        if (event.which == 13){
            this.page = 1;
            this.handleSearch();
        }    
    }

    buttonSearch(){
        this.page = 1;
        this.handleSearch();
    }


    previousHandler(){
        this.page = this.page-1;
        this.handleSearch();
    }
    nextHandler(){
        this.page = this.page+1;
        this.handleSearch();
    }

    handleSearch() {
        

        if(!this.strSearchAccName) {
            this.errorMsg = 'Porfavor introduce el nombre de una película.';
            this.searchData = undefined;
            this.numberResult = 0;
            this.totalPage = 1;
            return;
        }

        searchFilms({strFilmsName : this.strSearchAccName, page: this.page})
        .then(result => {
            this.searchData = result.Search.map(item=>{
                var typeText = item.Type == 'movie' ? 'Película' : item.Type
                typeText = typeText == 'series' ? 'Serie' : typeText
                typeText = typeText == 'episode' ? 'Episodio' : typeText
                typeText = typeText == 'game' ? 'Videojuego' : typeText

                return {...item,
                    Type: typeText,
                    "StylePoster":"posterCSS"
                }
            });
            this.numberResult = result.totalResults;
            this.totalPage = Math.ceil(result.totalResults/10);
            this.disableprev = this.page==1 ?  true : false;
            this.disablenext = this.page==this.totalPage ? true : false;



        })
        .catch(error => {   
            this.searchData = undefined;
            if(error) {
                if (Array.isArray(error.body)) {
                    this.errorMsg = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.errorMsg = error.body.message;
                }
            }
            this.numberResult = 0;
            this.totalPage = 1;
        }) 
    }

        



    renderedCallback(){ 
        loadStyle(this, style).then(()=>{
            console.log("Loaded Successfully")
        }).catch(error=>{ 
            console.error("Error in loading the colors")
        })
    }
        

}