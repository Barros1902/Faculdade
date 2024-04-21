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

int main() {

	char command[BUFSIZ];   /* Max readable size */
	char* discard;	/* Variable created to avoid ignoring return value of fgets */
	Stop* stop_head = NULL;
	Career* career_head = NULL;


	while (1){	/* Cycle that keeps asking for the input unless it's "q" */
		discard = fgets(command, BUFSIZ, stdin);
		switch (command[0]){
			case 'q':
				remove_all(&stop_head, &career_head);
				return 0;
			case 'c':
				carreiras(command, &career_head);
				break;
			case 'p':
				paragens(command, &stop_head, &career_head);
				break;
			
			case 'l':
				ligacoes(command, &stop_head, &career_head);
				break;
			
			case 'i':
				intersections(&stop_head, &career_head);
				break;

			case 'e':
				remove_stop(command, &stop_head, &career_head);
				break;
			
			case 'r':
				remove_career(command, &career_head);
				break;
			
			case 'a':
				remove_all(&stop_head, &career_head);
				break;
			
			case 't':
				continue;
				break;
			default:
				
				printf("Not a valid command\n");
				break;

		}
 
	}

(void)discard;  /* Void the return of fgets to aviod flag of not using it */
return 0;
}