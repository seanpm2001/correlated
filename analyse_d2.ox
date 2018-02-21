#include <oxstd.h>
#include <oxdraw.h>
#include <oxprob.h>

Parzen( const lag);
var_inflate(const lag, const mX);

/* Analyses output from the main file which is called:
   PF_SSFmult_dim2.ox
   */

main()
{

   // analyse 2 dim SSF for T=400, 1600
   // columns are: theta, accept (PMH) and 	vPar[][0:i]'~Z_prop[][0:i]'~Z_acc[][0:i]'~est_loglik[][0:i]'
   //			  	~vacc[][0:i]'~vW[][0:i]'~vWc[][0:i]' - 7 columns	 (CPMH)
	
	decl mX0 =  loadmat("mPar_MH.mat")[][]'; //mPar_6pt4k_MH2.mat MH
	decl mX =  loadmat( "mPar_CPM.mat" )[][]'; 	// mPar_6pt4k_CPM2.mat"mPar_1pt6k_CPMH2.mat"		 
	decl r = rows(mX), c =  columns(mX);
	print(r~c);	  //, mX[][1:10]
	Draw(0,mX[0][3000:(c-1)] , 0, 1);	 DrawTitle(0, " CPM: Draws of theta" );


	decl lag = 120;
	decl acfX = acf(mX[0][5100:(c-1)]', lag)[0:lag][]';
	Draw(1, acfX[0][], 0, 1);	 DrawTitle(1, " CPM: Correlogram of theta" );
	print(1 + 2 * sumc(acfX')); 
	lag = 20;
	acfX = acf(mX0[0][]', lag)[0:lag][]';
//	Draw(5, acfX[0][], 0, 1);
	print(1 + 2 * sumc(acfX')); 
//   Draw(2, mX[2][0:99], 0, 1);
	DrawDensity(2, mX[2][0:99]," Z under g()",  1, 1, 1);
	DrawDensity(2, mX[2][100:(c-1)]," Z under pi()",  3, 3, 3);

	Draw(3, mX[5][4000:(c-1)], 0, 1);   DrawTitle(3, " R=Z'-Z" );
	
	DrawDensity(4, mX[5][4000:(c-1)]," Histogram R=Z'-Z ",  1, 1, 1);
	lag = 100;
		acfX = acf(mX[5][2000:(c-1)]', lag)[0:lag][]';
	Draw(5, acfX[0][], 0, 1);	 DrawTitle(5, " correlogram of R=Z'-Z" );

	
	ShowDrawWindow();
//	SaveDrawWindow("a.eps")	;

}


Parzen( const lag)
{
  decl working, i;
  decl parzen = zeros(1, lag);
  for (i = 0; i < lag; i++)
  {
      working = double(i)/double(lag);
      if (working < 0.5)		  
		parzen[][i] = 1.0 - (6.0 * (working)^2) + (6.0 * (working)^3);
      else
		parzen[][i] = 2.0 * (1.0 - working)^3 ;
  }
  return parzen;
}

// mX 1*T.
var_inflate(const lag, const mX)
{
  decl acfX = acf(mX', lag)[1:lag][];
  decl par = ones(1, lag);//Parzen(lag);
  return 1 + 2 * sumc(acfX .* par');
}