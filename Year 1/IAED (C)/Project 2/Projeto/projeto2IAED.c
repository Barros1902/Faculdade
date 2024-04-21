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
#include "structs.h"
#define MAX_CAREERS 200 
#define MAX_NAME_CAREER 500
#define MAX_NOME_STOP 500
#define MAX_LINE_INTERSECTION 5000
#define NVALUE -1
/* Constants */


int its_inverso(char inv[]){	/* Verifies if the sort command is inverso */
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

void find_coordenates(char name[], Stop* head){ /* Finds coordenates for command p */

	int found = 0;
		for (; head != NULL ; head = head->next) {
			if (strcmp(head->name, name) == 0) {
				printf("%16.12f %16.12f\n", head->lat, head->lng);
				found = 1;
				break;
			}
		}
	if (found == 0){
		printf("%s: no such stop.\n", name);
	}


}

void create_stops(char* s, double lat, double lng, Stop** head){	/* Creates a stop */ /* If no stops then creates first else iterates till last and adds next */
	Stop* temp_head = NULL;
	if (*head == NULL){
		*head = malloc(sizeof(Stop));
		(*head)->name = malloc(sizeof(char)* MAX_NOME_STOP);
		findname(s, (*head)->name);
		(*head)->lat = lat;
		(*head)->lng = lng;
		(*head)->next = NULL;

	}
	else{

		temp_head = *head;
		while(temp_head->next != NULL){
			
			temp_head = temp_head->next;
		}
		
		temp_head->next = malloc(sizeof(Stop));
		temp_head->next->name = malloc(sizeof(char)* MAX_NOME_STOP);
		findname(s, temp_head->next->name);
		temp_head->next->lat = lat;
		temp_head->next->lng = lng;
		temp_head->next->next = NULL;

	}



}


void create_careers(char* s, Career** head){	/* Creates a stop */ /* If no stops then creates first else iterates till last and adds next */
	Career* temp_head = NULL;
	if (*head == NULL){
		*head = malloc(sizeof(Career));
		(*head)->name = malloc(sizeof(char)* MAX_NAME_CAREER);
		findname(s, (*head)->name);
		(*head)->first_con = NULL;
		(*head)->last_con = NULL;
		
	}
	else{

		temp_head = *head;
		while(temp_head->next != NULL){
			
			temp_head = temp_head->next;
		}
		
		temp_head->next = malloc(sizeof(Career));
		temp_head->next->name = malloc(sizeof(char)* MAX_NAME_CAREER);
		findname(s, temp_head->next->name);
		temp_head->next->first_con = NULL;
		temp_head->next->last_con = NULL;

	}



}



Career* Career_exists(char name[], Career* head) {  /* Verifies if the Career exists */
	for (; head != NULL ; head = head->next) {
		if (strcmp(head->name, name) == 0) {
			return head; 
		}
	}
	return NULL; 
}


Stop* stop_exists(char name[], Stop* head) {  /* Verifies if the stop exists */
	for (; head != NULL ; head = head->next) {
		if (strcmp(head->name, name) == 0) {
			return head; 
		}
	}
	return NULL; 
}


void printstops(Career* career){	/* Print the stops of the given career */
	Link* j;
	if(career->first_con != NULL){ /* Verifies if there are any connections */
		printf("%s", career->first_con->start->name);
		j = career->first_con;
		while (j != NULL){	/* Verifies if it was the last connection */
			printf(", %s", j->end->name);
			j = j->next;  /* Goes to the next link */
		}
		printf("\n");
	}
}



/* Print the stops of the given career backwards */
void printstopsreverse(Career* career){	/* Print the stops of the given career */
	Link* j;
	if(career->first_con != NULL){ /* Verifies if there are any connections */
		printf("%s", career->last_con->end->name);
		j = career->last_con;
		while (j != NULL){	/* Verifies if it was the first connection */
			printf(", %s", j->start->name);
			j = j->prev;  /* Goes to the previous link */
		}
		printf("\n");
	}
}


/* Finds the information about a specific career */
void infofinder(Career* career, double* cost, double* duration, int* stop_amount){
	Link* j; 
	int total_stops;
	double total_cost, total_duration;
	total_cost = 0; total_duration = 0, total_stops = 1;	/* total_stops =1 because (total_stops + 1) number of links */
	j = career->first_con;
	while (j != NULL){
		total_cost+= j->cost;
		total_duration+= j->duration;
		j = j->next;
		total_stops++;
	}
	*cost = total_cost;
	*duration = total_duration;
	*stop_amount = total_stops;

}

/* Finds the amount of careers that have a certain stop */
int amount_careers(Stop* stop, Career* career_head){

	int found, amount;
	Link* j;
	amount = 0;
	for(; career_head != NULL; career_head = career_head->next){
		found = NVALUE;
		j = career_head->first_con;
		while (j != NULL && found == NVALUE){
			if (j->end == stop || j->start == stop){
				found = 1;  /* Stop searching if it finds the stop in the career */
				amount++;
			}
			j = j->next;
		}
	}
	return amount;
}



void paragens(char s[], Stop** head, Career** head_career){	/* Recieves the input if it starts with a "p" */
	Stop* temp_head;
	double lat = 0, lng = 0;
	char name[MAX_NOME_STOP];
	temp_head = *head;
	s += 2; /* Removes the command "p" */
	if (strcmp(s, "") == 0) { /* If the command was "p" enters the if */
		for (; (temp_head)!= NULL ;temp_head = temp_head->next) {
			printf("%s: %16.12f %16.12f %d\n",
			(temp_head)->name, (temp_head)->lat, (temp_head)->lng, amount_careers(temp_head, *head_career));
		}
		return;
	}
	if (s[0] == '\"'){  /* If the input had quotes on the stop name enters the if */
		if (sscanf(s, "\"%[^\"]\"%lf%lf", name, &lat, &lng) == 1)   /* Only enters if no coordenates were given */
			find_coordenates(name, *head);
		else{
			sscanf(s, "\"%[^\"]\"%lf%lf", name, &lat, &lng);
			if(stop_exists(name, *head)== NULL) /* Verifies if the stop already exists */
				create_stops(s, lat, lng, head);  /* If it doesn't exist already then it's created */
			else 
				printf("%s: stop already exists.\n", name);
		}
	}
	else{ /* If the input had no quotes on the stop name enters */
		if (sscanf(s, "%s %lf %lf", name, &lat, &lng) == 1) 
			find_coordenates(name, *head);
		else{
			sscanf(s, "%s %lf %lf", name, &lat, &lng);
			if(stop_exists(name, *head) == NULL) /* Verifies if the stop already exists */
				create_stops(s, lat, lng, head);  /* If it doesn't exist already then it's created */
			else 
				printf("%s: stop already exists.\n", name);
		}
	}


}


void carreiras(char s[], Career** head){   /* Recieves the input if it starts with a "c" */
	Career *temp_head, *ID;
	char discard, career[MAX_NAME_CAREER], inv[8];
	int stop_amount;
	double cost, duration;
	temp_head = NULL; ID = NULL;
	temp_head = *head;
	cost = 0; duration = 0; stop_amount = 0;
	
	if (sscanf(s, "%s %s %s", &discard, career, inv) == 2){ /* Enters if the command is c and a career  */
		ID = Career_exists(career, *head);
		if (ID == NULL){
			create_careers(career, head);
		}
		else {
			printstops(ID);

		}	
	}
	if (sscanf(s, "%s %s %s", &discard, career, inv) == 1){
		if (*head != NULL){
			for (; (temp_head)!= NULL ;temp_head = temp_head->next){
				if(temp_head->first_con == NULL){
					printf("%s %d %.2f %.2f\n", temp_head->name, 0, 0.0, 0.0);		   
				}
				else{
					infofinder(temp_head, &cost, &duration, &stop_amount);
					printf("%s %s %s %d %.2f %.2f\n", temp_head->name, 
					temp_head->first_con->start->name,
					temp_head->last_con->end->name, stop_amount, cost, duration);  
				} 
			}
		}
	}
	if (sscanf(s, "%s %s %s", &discard, career, inv) == 3){
		ID = Career_exists(career, *head);
		if(ID != NULL && its_inverso(inv) != NVALUE)
			printstopsreverse(ID);


	}
 }

void ligacoes(char s[], Stop** head_stops, Career** head_careers){	/* Recieves the input if it starts with a "l" */
	char carreira[MAX_NAME_CAREER], par_ini[MAX_NOME_STOP], par_fin[MAX_NOME_STOP];
	float cost, dur;
	Career* ID;
	Stop *IDP1, *IDP2;
	Link* New_link;
	s+=2;
	extract_values(s, carreira, par_ini, par_fin, &cost, &dur);
	ID = Career_exists(carreira, *head_careers);
	IDP1 = stop_exists(par_ini, *head_stops);
	IDP2 = stop_exists(par_fin, *head_stops);
	if (ID == NULL)
		printf("%s: no such line.\n", carreira);

	if(IDP1 == NULL)
		printf("%s: no such stop.\n", par_ini);

	if(IDP2 == NULL)
		printf("%s: no such stop.\n", par_fin);

	if(cost < 0 || dur < 0)
		printf("negative cost or duration.\n");

	if(ID != NULL && IDP1 != NULL && IDP2 != NULL && cost >= 0 && dur >= 0){
    	New_link = (Link*) malloc(sizeof(Link)); /* allocate memory */
		New_link->start = IDP1;
		New_link->end = IDP2;
		New_link->cost = cost;
		New_link->duration = dur;
		if (ID->first_con == NULL && ID->last_con == NULL) {
			/* add first link */
			New_link->prev = NULL;
			New_link->next = NULL;
			ID->first_con = New_link;
			ID->last_con = New_link;
		} 
		else if (ID->last_con->end == IDP1) {
			/* add link to end */
			New_link->prev = ID->last_con;
			New_link->next = NULL;
			ID->last_con->next = New_link;
			ID->last_con = New_link;
		} 
		else if (ID->first_con->start == IDP2) {
			/* add link to beginning */
			New_link->prev = NULL;
			New_link->next = ID->first_con;
			ID->first_con->prev = New_link;
			ID->first_con = New_link;
		}
		else{
			free(New_link);
			printf("link cannot be associated with bus line.\n");
		}
	}
	
}


void intersections(Stop** stop_head, Career** career_head) {
    Stop* curr_stop = *stop_head;
    int amount, found;
    char i_stop[MAX_LINE_INTERSECTION];
    char amount_str[MAX_CAREERS];
    char stop_career[MAX_LINE_INTERSECTION];
    Career* curr_career;
    Link* curr_link;
    
    while (curr_stop != NULL) {
        amount = amount_careers(curr_stop, *career_head);
        if (amount > 1) {
            i_stop[0] = '\0';
            stop_career[0] = '\0';
            
            sprintf(amount_str, "%d", amount);
            strcat(i_stop, curr_stop->name);
            strcat(i_stop, " ");
            strcat(i_stop, amount_str);
            strcat(i_stop, ":");
            
            curr_career = *career_head;
            while (curr_career != NULL) {
                found = 0;
                curr_link = curr_career->first_con;
                
                while (curr_link != NULL && !found) {
                    if (curr_link->end == curr_stop || curr_link->start == curr_stop) {
                        found = 1;
                        strcat(stop_career, " ");
                        strcat(stop_career, curr_career->name);
                    }
                    curr_link = curr_link->next;
                }
                
                curr_career = curr_career->next;
            }
            count_sort_words(stop_career);
            strcat(i_stop, stop_career);
            i_stop[strlen(i_stop)-1] = '\0';
            printf("%s\n", i_stop);
        }
        curr_stop = curr_stop->next;
    }
}



void remove_stop_array(char name[], Stop** head){

	Stop *temp_head = NULL, *prev = NULL;
    temp_head = *head;
	name[strlen(name)-1] = '\0';
	name+=2;
    /* If the first stop is to be removed */
    if (strcmp((*head)->name, name) == 0) {
        *head = (*head)->next;
        free(temp_head->name);
        free(temp_head);
        return;
    }

    /* Find the stop to be removed and its previous stop */
    while (temp_head != NULL && strcmp(temp_head->name, name) != 0) {
        prev = temp_head;
        temp_head = temp_head->next;
    }

    /* If the stop is not found in the list */
    if (temp_head == NULL) {
        printf("%s: no such stop.\n", name);
        return;
    }

    /* Remove the stop from the list */
    prev->next = temp_head->next;
    free(temp_head->name);
    free(temp_head);
	
    return;

}
    


void remove_stop_links(char name[], Stop** stop_head, Career** career_head){
	
	Career* temp_head_career = *career_head;
	Link *j;
	if((*stop_head) == NULL || (*career_head) == NULL)
		return;
	
	for(;temp_head_career != NULL; temp_head_career = temp_head_career->next){
		j = temp_head_career->first_con;
		if(j->next == NULL && (strcmp(name, j->start->name) || strcmp(name, j->end->name))){
			temp_head_career->first_con = NULL;
			
			free(j);
		}


		
		for(;j->next != NULL; j = j->next){
		continue;
		
		}


	}


}
void stop_in_career(char name[], Career* career){
	Link* link;
    Stop* stop;

    
    for(link = career->first_con; link != NULL; link = link->next){
        for(stop = link->start; stop != NULL; stop = stop->next){
            if(strcmp(name, stop->name) == 0){
                printf("%s (%f, %f)\n", stop->name, stop->lat, stop->lng);
            }
        }
    }
}	


void remove_stop(char name[], Stop** stop_head, Career** career_head) {

	remove_stop_links(name, stop_head, career_head);
	remove_stop_array(name, stop_head);
	
   
}

void remove_career(char name[], Career** career_head) {
	
    Career* prev_career = NULL;
    Career* current_career = *career_head;
    Link* current_link = NULL;
    Link* temp_link = NULL;
	name[strlen(name)-1] = '\0';
	name+=2;
    /* Find the career to remove */
    while (current_career != NULL && strcmp(current_career->name, name) != 0) {
        prev_career = current_career;
        current_career = current_career->next;
    }

    /* If career is not found */
    if (current_career == NULL) {
        printf("%s: no such line.\n", name);
        return;
    }

    /* Remove the career */
    if (prev_career == NULL) {
        *career_head = current_career->next;
    } else {
        prev_career->next = current_career->next;
    }

    /* Free the links in the career */
    current_link = current_career->first_con;
    while (current_link != NULL) {
        temp_link = current_link;
        current_link = current_link->next;
        free(temp_link);
    }

    /* Free the career */
	free(current_career->name);
    free(current_career);
}


void remove_all(Stop** stop_head, Career** career_head){/* Free all */
	Stop* current_stop = *stop_head;
	Career* current_career = *career_head;
	Link *current_link, *aux;
    while (current_stop != NULL) {
        *stop_head = current_stop->next;
		free(current_stop->name);
        free(current_stop);
        current_stop = *stop_head;
    }
	while (current_career != NULL){
		*career_head = current_career->next;
		current_link = current_career->first_con;

		while (current_link != NULL){
			
			aux = current_link->next;
			free(current_link);
			current_link = aux;


		}
		free(current_career->name);
		free(current_career);
		current_career = *career_head;
	}
}

