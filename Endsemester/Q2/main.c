#include <at89c5131.h>
#include "endsem.h"

//char S_str[6]= {0,0,0,0,0,0};   //String for Balance Sita
//char G_str[6] = {0,0,0,0,0,0};  //String for Balance Gita
char n500_s[3]= {0,0,0};    // STRING FOR 500RS NOTE
char n100_s[3]= {'0',0,0};    // STRING FOR 100RS NOTE
 unsigned int acbal_1=10000;
        unsigned int acbal_2=10000;
//char password[5] = {0,0,0,0,0} ;   //PASSWORD ARRAY
//Main function

//-------------------------------------------------
void main(void)
{
	uart_init();  
	// Please finish this function in endsem.h
    while (1)
    {
        unsigned char ch=0;
        unsigned char ac=0;
        unsigned char in2=0;
        unsigned char in1=0;
        unsigned int input_amount=0;
        unsigned int am2=0;
        unsigned int am1=0;
        unsigned int rs100=0;
        unsigned int rs500=0;
				

       
        unsigned char acrem1 =0;
        unsigned char acrem2 =0;
			  unsigned char input =0;
        unsigned char rs500_ch =0;
        unsigned char rs100_ch =0;


        // YOUR CODE GOES HERE
        transmit_string("Press A for Account display and W for withdrawing cash\r\n");

        ch = receive_char();

        switch(ch)
        {
            case 'A':
                     transmit_string("Hello, Please enter Account Number\r\n");
										 ac = receive_char();

                     switch(ac)
                     {
                        case '1':
                             	  transmit_string("Account Holder: Sita \r\n");
                                transmit_string("Account Balance: 10000\r\n");
                                break;
                        case '2':
                             	  transmit_string("Account Holder: Gita \r\n");
                                transmit_string("Account Balance: 10000\r\n");
                                break;
                        default:transmit_string("No such account, please enter valid details\r\n");
                                break;
                     }
                     break;

            case 'W':
                     transmit_string("Withdraw state, enter account number\r\n");
										 ac = receive_char();
                     switch(ac)
                     {
                        case '1':
                                transmit_string("Account Holder: Sita \r\n");
                                transmit_string("Account Balance: 10000\r\n");
                                transmit_string("Enter Amount, in hundreds\r\n");
                                in2=receive_char();
                                if (in2 =='1' || in2 =='2'||in2 =='3' || in2 =='4'||in2 =='5' || in2 =='6'||in2 =='7' || in2 =='8'||in2 =='9' || in2 =='0'){
                                   am2= in2 -48 ;
                                }
                                else{
                                   transmit_string("Invalid Amount\r\n");
                                   break;
                                }
                                in1=receive_char();
                                if (in1 =='1' || in1 =='2'||in1 =='3' || in1 =='4'||in1 =='5' || in1 =='6'||in1 =='7' || in1 =='8'||in1 =='9' || in1 =='0'){
                                   am1= in1 -48;
                                }
                                else{
                                   transmit_string("Invalid Amount\r\n");
                                   break;
                                }

                                input_amount = 1000*am2 +100*am1;
																int_to_string(input_amount, &input);
																transmit_string(&input);
																transmit_string("\r\n");

                                if (input_amount<=acbal_1){
																if(am2>=5){
																n500_s[0]= '1';
																	n500_s[1]= (10*am2+am1)/5 -10 +48;}
																else {
																	n500_s[0]= '0';
																	n500_s[1]= (10*am2+am1)/5 +48;}
																	
                                rs500 = (10*am2+am1)/5;
																
																//input= rs500+48;
																//transmit_string(&input);
																//transmit_string("\r\n");
                                n100_s[1] = am1%5+48;
                                acbal_1 -= input_amount;
                                int_to_string(acbal_1, &acrem1);
                                //int_to_string(rs500, &rs500_ch);
                                //int_to_string(rs100, &rs100_ch);

                                transmit_string("Remaining Balance:");
								transmit_string(&acrem1);
								transmit_string("\r\n");

                                transmit_string("500 Notes:");
								transmit_string(&n500_s);
                                transmit_string(" ,100 Notes:");
								transmit_string(&n100_s);
								transmit_string("\r\n");
                                }
                                else {
                                    transmit_string("Insufficient Funds\r\n");
                                    break;
                                }

                                break;
                        case '2':
                             	  transmit_string("Account Holder: Gita \r\n");
                                transmit_string("Account Balance: 10000\r\n");
                                transmit_string("Enter Amount, in hundreds\r\n");
                                in2=receive_char();
                                if (in2 =='1' || in2 =='2'||in2 =='3' || in2 =='4'||in2 =='5' || in2 =='6'||in2 =='7' || in2 =='8'||in2 =='9' || in2 =='0'){
                                   am2= in2 - 48;
                                }
                                else{
                                   transmit_string("Invalid Amount\r\n");
                                   break;
                                }
                                in1=receive_char();
                                if (in1 =='1' || in1 =='2'||in1 =='3' || in1 =='4'||in1 =='5' || in1 =='6'||in1 =='7' || in1 =='8'||in1 =='9' || in1 =='0'){
                                   am1= in1 - 48;
                                }
                                else{
                                   transmit_string("Invalid Amount\r\n");
                                   break;
                                }

                                input_amount = 1000*am2 +100*am1;

                                /*if (input_amount<=acbal_2){
                                rs500 = input_amount%500;
                                rs100 = (input_amount - ((input_amount%500) *500))%100;
                                acbal_2 = 10000-input_amount;
                                int_to_string(acbal_2, &acrem2);
                                int_to_string_2(rs500, &rs500_ch);
                                int_to_string_2(rs100, &rs100_ch);

								transmit_string("Remaining Balance:");
								transmit_string(&acrem2);
								transmit_string("\r\n");

                                transmit_string("500 Notes:");
								transmit_string(&rs500_ch);
                                transmit_string(" ,100 Notes:");
								transmit_string(&rs100_ch);
								transmit_string("\r\n");


                                }
                                else {
                                    transmit_string("Insufficient Funds\r\n");
                                    break;
                                }*/
                                break;


                        default:transmit_string("No such account, please enter valid details\r\n");
                                break;
                     }
                     break;

            default://transmit_string("Incorrect test. Pass correct number\r\n");
                    break;

        }

    }

}


