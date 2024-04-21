/* iaed-23 - ist1106588 - project1 */
/*
 * File:  project1.c
 * Author:  Tomás Barros
 * Description: Program that creates and manages a public transportation system
*/

/* Libraries */

#include <stdio.h>
#include <stdlib.h> 
#include <ctype.h>
#include <string.h>

/* Constants */

#define MAX_CAREERS 200
#define MAX_STOPS 10000
#define MAX_LINKS 30000
#define MAX_NAME_CAREER 21
#define NVALUE -1 /*Value that defines errors*/
#define MAX_NOME_STOP 51
#define MAX_LINE_INTERSECTION 4255


typedef struct {
    char name[MAX_NOME_STOP];
    double lat;
    double lng;

} Stop;

typedef struct {
    char name[MAX_NAME_CAREER];
    int first_con;  /* First connecting of a Career */
    int last_con;   /* First connecting of a Career */



} Career;

typedef struct {
    int start;  /* First stop of the link*/
    int end;    /* First stop of the link*/
    int next;   /* Bridge to the next link associated to this link */
    int prev;   /* Bridge to the previous link associated to this link */
    float cost;
    float duration;


} Link;

/* Global variables that count amounts */

int Carreiras_num = 0;  
int Links_num = 0;
int num_stops = 0;

/* Global arrays to store Careers Stops and Links respectively */

Career Carreiras[MAX_CAREERS];
Stop stops[MAX_STOPS];
Link Links[MAX_LINKS]; 



int its_inverso(char inv[]){    /* Verifies if the sort command is inverso */
    size_t i;
    if (strlen(inv) > strlen("inverso") || strlen(inv) < strlen("inv")){
        printf("incorrect sort option.\n");
        return NVALUE;
    }
    else{ 
        for(i = 0; i < (strlen(inv)); i++){
            if (inv[i] == "inverso"[i])
                continue;
            else{
                printf("incorrect sort option.\n");
                return NVALUE;
            }
        }    
    }
    return 0;

}


void count_sort_words(char* str) {  /* Sorts the stops for command i */
    int i, j, count = 0, word_index = 0;
    char* word_ptr = str;
    char words[MAX_CAREERS][MAX_NAME_CAREER];  /* Create an array to hold each word */
    /* Count the number of words in the string */
    while (*word_ptr) {
        if (*word_ptr == ' ') {
            count++;
        }
        word_ptr++;
    }
    count++;  /* Add one more for the last word in the string */

    memset(words, 0, sizeof(words));  /* Initialize the array to all zeros */

    /* Split the string into individual words and store them in the array*/
    word_ptr = strtok(str, " ");
    while (word_ptr != NULL) {
        strcpy(words[word_index], word_ptr);
        word_index++;
        word_ptr = strtok(NULL, " ");
    }

    /* Sort the array of words using the selection sort algorithm*/
    for (i = 0; i < count - 1; i++) {
        int min_index = i;
        min_index = i;
        for (j = i + 1; j < count; j++) {
            if (strcmp(words[j], words[min_index]) < 0) {
                min_index = j;
            }
        }
        if (min_index != i) {
            char temp[256];
            strcpy(temp, words[i]);
            strcpy(words[i], words[min_index]);
            strcpy(words[min_index], temp);
        }
    }

    /* Combine the sorted words into a single string and store it back in the original string*/
    strcpy(str, "");
    for (i = 0; i < count; i++) {
        strcat(str, words[i]);
        strcat(str, " ");
    }
}






/* Extract the values for the l command */
int extract_values
(char *s, char* carreira, char *name1, char *name2, float *cost, float *dur) {
    int result = 0;
    /* Case for two stops with quotes */
    if (sscanf(s, "%s \"%[^\"]\" \"%[^\"]\" %f %f",
        carreira, name1, name2, cost, dur) == 5) {
        result = 1;
    /* Case for one stop with quotes and other without */
    } else if (sscanf(s, "%s \"%[^\"]\" %s %f %f ",
        carreira, name1, name2, cost, dur) == 5) {
        result = 1;
    /* Case for a stop without quotes and other with*/
    } else if (sscanf(s, "%s %s \"%[^\"]\" %f %f ",
        carreira, name1, name2, cost, dur) == 5) {
        result = 1;
    /* Case for two stops without quotes */
    } else if (sscanf(s, "%s %s %s %f %f ",
        carreira, name1, name2, cost, dur) == 5) {
        result = 1;
    
    }               
    return result;
}


char* findname(char s[], char name[]){  /* If name have quotes removes them */
    
    if (sscanf(s, "\"%[^\"]\"", name) == 1)
        return name;
    sscanf(s, "%s", name);
    return name;
}

void find_coordenates(char name[]){ /* Finds coordenates for command p */

    int i, found = 0;
        for (i = 0; i < num_stops; i++) {
            if (strcmp(stops[i].name, name) == 0) {
            printf("%16.12f %16.12f\n", stops[i].lat, stops[i].lng);
            found = 1;
            break;
            }
        }
    if (found == 0){
            printf("%s: no such stop.\n", name);
        }


}

void create_stops(char s[], double lat, double lng){    /* Creates a stop */

    findname(s, stops[num_stops].name);
    stops[num_stops].lat = lat;
    stops[num_stops].lng = lng;
    num_stops++;



}

int Career_exists(char name[]){   /* Verifies if the career exists */
    int i;
    for(i=0; i < Carreiras_num; i++){
        if(strcmp(Carreiras[i].name, name)==0)
            return i;
    }
    return NVALUE;
}


int stop_exists(char name[]) {  /* Verifies if the stop exists */
    int i;
    for (i = 0; i < num_stops; i++) {
        if (strcmp(stops[i].name, name)== 0) {
            return i; 
        }
    }
    return NVALUE; 
}




void printstops(int ID){    /* Print the stops of the given career */
    int j;
    if(Carreiras[ID].first_con != NVALUE){ /* Verifies if there are any connections */
        printf("%s", stops[Links[Carreiras[ID].first_con].start].name);
        j = Carreiras[ID].first_con;
        while (j != NVALUE){    /* Verifies if it was the last connection */
            printf(", %s", stops[Links[j].end].name);
            j = Links[j].next;  /* Goes to the next link */
        }
        printf("\n");
    }
}


/* Print the stops of the given career backwards */
void printstopsreverse(int ID){    
    int j;
    if(Carreiras[ID].first_con != NVALUE){ /* Verifies if there are any connections */
        printf("%s", stops[Links[Carreiras[ID].last_con].end].name);
        j = Carreiras[ID].last_con;
        while (j != NVALUE){    /* Verifies if it was the first connection */
            printf(", %s", stops[Links[j].start].name);
            j = Links[j].prev;  /* Goes to the previous link */
        }
        printf("\n");
    }
}

/* Finds the information about a specific career */
void infofinder(int ID, float* cost, float* duration, int* stop_amount){
    int j, total_stops;
    float total_cost, total_duration;
    total_cost = 0; total_duration = 0, total_stops = 1;    /* total_stops =1 because (total_stops + 1) number of links */
    j = Carreiras[ID].first_con;
    while (j != NVALUE){
        total_cost+= Links[j].cost;
        total_duration+= Links[j].duration;
        j = Links[j].next;
        total_stops++;
    }
    *cost = total_cost;
    *duration = total_duration;
    *stop_amount = total_stops;

}


/* Finds the amount of careers that have a certain stop */
int amount_careers(int stop_num){

    int i, j, found, amount;
    amount = 0;
    for(i = 0; i < Carreiras_num; i++){
        found = NVALUE;
        j = Carreiras[i].first_con;
        while (j != NVALUE && found == NVALUE){
            if (Links[j].end == stop_num || Links[j].start == stop_num){
                found = 1;  /* Stop searching if it finds the stop in the career */
                amount++;
            }
            j = Links[j].next;
        }
    }
    return amount;
}



void paragens(char s[]){    /* Recieves the input if it starts with a "p" */
    int i = 0;
    double lat = 0, lng = 0;
    char name[MAX_NOME_STOP];
    s += 2; /* Removes the command "p" */
    if (strcmp(s, "") == 0) { /* If the command was "p" enters the if */
        for (i = 0; i < num_stops; i++) {
            printf("%s: %16.12f %16.12f %d\n",
            stops[i].name, stops[i].lat, stops[i].lng, amount_careers(i));
        }
        return;
    }
    if (s[0] == '\"'){  /* If the input had quotes on the stop name enters the if */
        if (sscanf(s, "\"%[^\"]\"%lf%lf", name, &lat, &lng) == 1)   /* Only enters if no coordenates were given */
            find_coordenates(name);
        else{
            sscanf(s, "\"%[^\"]\"%lf%lf", name, &lat, &lng);
            if(stop_exists(name)== NVALUE)  /* Verifies if the stop already exists */
                create_stops(s, lat, lng);  /* If it doesn't exist already then it's created */
            else 
                printf("%s: stop already exists.\n", name);
        }
    }
    else{ /* If the input had no quotes on the stop name enters */
        if (sscanf(s, "%s %lf %lf", name, &lat, &lng) == 1) 
            find_coordenates(name);
        else{
            sscanf(s, "%s %lf %lf", name, &lat, &lng);
            if(stop_exists(name) == NVALUE) /* Verifies if the stop already exists */
                create_stops(s, lat, lng);  /* If it doesn't exist already then it's created */
            else 
                printf("%s: stop already exists.\n", name);
        }
    }


}



void carreiras(char s[]){   /* Recieves the input if it starts with a "c" */
    Career New;
    char discard, career[MAX_NAME_CAREER], inv[8];
    int ID, i, stop_amount;
    float cost, duration;
    
    if (sscanf(s, "%s %s %s", &discard, career, inv) == 2){ /* Enters if the command is c and a career  */
        ID = Career_exists(career);
        if (ID == -1){
            
            strcpy(New.name, career);
            New.first_con = NVALUE;
            New.last_con = NVALUE;
            Carreiras[Carreiras_num] = New;
            Carreiras_num++;

        }
        else {
            printstops(ID);

        }    
    }
    if (sscanf(s, "%s %s %s", &discard, career, inv) == 1){
        if (Carreiras_num != 0){
            for( i = 0; i < Carreiras_num; i++){
                if(Carreiras[i].first_con == NVALUE){
                    printf("%s %d %.2f %.2f\n", Carreiras[i].name, 0, 0.0, 0.0);           
                }
                else{
                    infofinder(i, &cost, &duration, &stop_amount);
                    printf("%s %s %s %d %.2f %.2f\n", Carreiras[i].name, 
                    stops[Links[Carreiras[i].first_con].start].name,
                    stops[Links[Carreiras[i].last_con].end].name, stop_amount, cost, duration);  
                }      
            }
        }
    }
    if (sscanf(s, "%s %s %s", &discard, career, inv) == 3){
        ID = Career_exists(career);
        if(ID != NVALUE && its_inverso(inv) != NVALUE)
            printstopsreverse(ID);


    }
 }











void ligacoes(char s[]){    /* Recieves the input if it starts with a "l" */
    char carreira[MAX_NAME_CAREER], par_ini[MAX_NOME_STOP], par_fin[MAX_NOME_STOP];
    float cost, dur;
    int ID, IDP1, IDP2;
    s+=2;
    extract_values(s, carreira, par_ini, par_fin, &cost, &dur);
    ID = Career_exists(carreira);
    IDP1 = stop_exists(par_ini);
    IDP2 = stop_exists(par_fin);
    if (ID == NVALUE)
        printf("%s: no such line.\n", carreira);

    if(IDP1 == NVALUE)
        printf("%s: no such stop.\n", par_ini);

    if(IDP2 == NVALUE)
        printf("%s: no such stop.\n", par_fin);

    if(cost < 0 || dur < 0)
        printf("negative cost or duration.\n");

    if(ID != NVALUE && IDP1 != NVALUE && IDP2 != NVALUE && cost >= 0 && dur >= 0){
        
        if (Carreiras[ID].first_con == NVALUE && Carreiras[ID].last_con == NVALUE){
            Carreiras[ID].first_con = Links_num;
            Carreiras[ID].last_con = Links_num; 
            Links[Links_num].start = IDP1;
            Links[Links_num].end = IDP2;
            Links[Links_num].prev = NVALUE;
            Links[Links_num].next = NVALUE;
            Links[Links_num].cost = cost;
            Links[Links_num].duration = dur;
            Links_num++;

        }
        else if (Links[Carreiras[ID].last_con].end == IDP1){ /*Add stop at the end*/
            Links[Links_num].start = IDP1;
            Links[Links_num].end = IDP2;
            Links[Links_num].prev = Carreiras[ID].last_con;
            Links[Links_num].next = NVALUE;
            Links[Carreiras[ID].last_con].next = Links_num;
            Links[Links_num].cost = cost;
            Links[Links_num].duration = dur;
            Carreiras[ID].last_con = Links_num;
            Links_num++;
        }
        else if(Links[Carreiras[ID].first_con].start == IDP2){
            Links[Links_num].start = IDP1;
            Links[Links_num].end = IDP2;
            Links[Links_num].next = Carreiras[ID].first_con;
            Links[Links_num].prev = NVALUE;
            Links[Carreiras[ID].first_con].prev = Links_num;
            Links[Links_num].cost = cost;
            Links[Links_num].duration = dur;
            Carreiras[ID].first_con = Links_num;
            Links_num++;
        }
        else{
            printf("link cannot be associated with bus line.\n");
        }
    }
    
}

void intersections(){   /* Recieves the input if it starts with a "i" */
    int i, j,k, found, amount;
    char amount_str[MAX_CAREERS];
    char i_stop[MAX_LINE_INTERSECTION];
    char stop_carrer[MAX_LINE_INTERSECTION];
    for(i = 0; i < num_stops; i++){
        i_stop[0] = '\0';
        stop_carrer[0] = '\0';
        amount = amount_careers(i);
        if (amount > 1){
            sprintf(amount_str, "%d", amount);
            strcat(i_stop, stops[i].name);
            strcat(i_stop, " ");
            strcat(i_stop, amount_str);
            strcat(i_stop, ":");
            
            for(k = 0; k < Carreiras_num; k++){
                found = NVALUE;
                j = Carreiras[k].first_con;
                while (j != NVALUE && found == NVALUE){
                    if (Links[j].end == i || Links[j].start == i){
                        found = 1;
                        strcat(stop_carrer, " ");
                        strcat(stop_carrer, Carreiras[k].name);
                        
                    }
                    j = Links[j].next;
                }
            }
            count_sort_words(stop_carrer);
            strcat(i_stop, stop_carrer);
            i_stop[strlen(i_stop)-1] = '\0';
            printf("%s\n", i_stop);
        }
    }

}

int main() {

    char command[BUFSIZ];   /* Max readable size */
char* discard;    /* Variable created to avoid ignoring return value of fgets */
    while (1){    /* Cycle that keeps asking for the input unless it's "q" */
        discard = fgets(command, BUFSIZ, stdin);
        switch (command[0]){
            case 'q':
                return 0;
            case 'c':
                carreiras(command);
                break;
            case 'p':
                paragens(command);
                break;
            case 'l':
                ligacoes(command);
                break;
            case 'i':
                intersections();
                break;

            default:
                
                printf("Not a valid command\n");
                break;

        }
 
    }

(void)discard;  /* Void the return of fgets to aviod flag of not using it */
return 0;
}