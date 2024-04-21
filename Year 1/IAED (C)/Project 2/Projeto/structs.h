#include <stdio.h>
#include <stdlib.h> 
#include <ctype.h>
#include <string.h>

typedef struct Stop Stop;
typedef struct Career Career;
typedef struct Link Link;


struct Stop {
	char* name;
	double lat;
	double lng;
	Stop* next;

};

struct Career {
	char* name;
	Link* first_con;  /* First connecting of a Career */
	Link* last_con;   /* First connecting of a Career */
	Career* next;


};

struct Link {
	Stop* start;  /* First stop of the link*/
	Stop* end;	/* First stop of the link*/
	Link* next;   /* Bridge to the next link associated to this link */
	Link* prev;   /* Bridge to the previous link associated to this link */
	float cost;
	float duration;

};

void paragens(char s[], Stop** head, Career** head_career);
void carreiras(char s[], Career** head);
void ligacoes(char s[], Stop** head_stops, Career** head_careers);
void intersections(Stop** stop_head, Career** career_head);
void remove_stop(char name[], Stop** head, Career** career_head);
void remove_all(Stop** stop_head, Career** career_head);
void remove_career(char name[], Career** career_head);