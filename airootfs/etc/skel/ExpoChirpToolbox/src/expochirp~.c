/* 
expochirp~ version 0.91
An object class for Pure Data. Produces an exponential chirp.
copyright Katja Vetter, feb 21 2011.

(katjavetter@gmail.com, www.katjaas.nl) 

This software is published under standard BSD licensing terms.
THE AUTHOR MAKES NO WARRANTY, EXPRESS OR IMPLIED,
IN CONNECTION WITH THIS SOFTWARE! 


Based on Pure Data by Miller Puckette and others.


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

[expochirp~] implements the following exponential chirp formula:

sin(((pi/2^p*L)/ln(2^p)) * e^((n/N)*ln(2^p)))

condition: ((pi/2^p)*L/ln(2^p)) = M*2*pi , an integer multiple of 2pi, computed from maximum chirpsize and nr of octaves as set by user

M = a positive integer 
L = a decimal number (floating point number) expressing chirpsize in unity samples
N = ceil(L), that is L rounded up to an integer, the real arraysize
p = the integer number of octaves in the chirp (user argument)

((pi/2^p*L)/ln(2^p)) is a constant, a scaling factor
e^((n/N)*ln(2^p)) is an exponential curve

If x[n] is the chirp, the inverse chirp is formulated:

x[N-n] * (2^(p/N))^-n * p * ln(2) / (1-2^p)       (was x[N-n] * 2^(p/N))^-n * -ln(1/2^p) in [expochirp~] version 0.9)

If a fade-in window is applied (default), the window runs over the full first octave.
The window is the first quarter cycle of a sine wave.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

version history;

version 0.9: first version

version 0.91: inverse chirp scaling factor replaced (see chirp formula description)

*/


#include "m_pd.h"							// Pure Data header file
#include <math.h>

#define PI 3.141592653589793
#define HALFPI 1.570796326794897
#define MAXCHIRPSIZEDEFAULT 1000000		// default maximum chirpsize, one million
#define MAXCHIRPSIZEMAX 8000000			// maximum maximum chirpsize, 8 million 
#define OCTAVESDEFAULT 11				// number of octaves in the chirp
#define OCTAVESMIN 5
#define OCTAVESMAX 15
#define FADEINDEFAULT 1					// long fade-in window

// global pointer to class struct
static t_class *expochirp_class;


// expochirp~ class struct
typedef struct
{
	t_object x_obj;	
	int octaves;
	int chirpsize;
	int octavesize;
	int maxsize;
	int fadein;
	double fadeinangle;
	double expconstant;
	double logoctavepow;
	double scalefactor;
	double anglecorrection;
	double invcurvebase;
	double invscalefactor;
	int countdown;
	int countup;
	t_outlet *chirpsizeoutlet;
	t_clock *chirpsizeclock;
} t_expochirp;


static void expochirp_tick(t_expochirp *x)
{
	outlet_float(x->chirpsizeoutlet, x->chirpsize);
}


static void *expochirp_new(t_symbol *symbol)
{
	t_expochirp *x = (t_expochirp *)pd_new(expochirp_class);
	outlet_new(&x->x_obj, gensym("signal"));
	outlet_new(&x->x_obj, gensym("signal"));
	x->chirpsizeoutlet = outlet_new(&x->x_obj, &s_float);
	x->maxsize = MAXCHIRPSIZEDEFAULT;
	x->octaves = OCTAVESDEFAULT;
	x->fadein = FADEINDEFAULT;
	x->countdown = 0;
	x->countup = 0;
	x->chirpsizeclock = clock_new(x, (t_method)expochirp_tick);
	return (x);
}
// end of expochirp_new function definition


static void expochirp_free(t_expochirp *x)
{
	if(x->chirpsizeclock) clock_free(x->chirpsizeclock);
}


static inline double modulo_twopi(double angle)
{
	double cycles;
	int integercycles;
	double remainder;
	
	cycles = angle / (2. * PI);
	integercycles = (int)cycles;
	remainder = cycles - integercycles;
	return remainder *= 2. * PI;
}	


static t_int *expochirp_perform(t_int *w)
{
	t_expochirp *x = (t_expochirp *)(w[1]);
	t_sample *chirpout = (t_sample *)(w[2]);						// audio signal input
	t_sample *invchirpout = (t_sample *)(w[3]);
	t_int blocksize = (t_int)(w[4]);
	
	int countdown = x->countdown;
	int countup = x->countup;
	int fadein = 0, invfadein = 0;
	double scalefactor = x->scalefactor;
	double logoctavepow = x->logoctavepow;
	double invscalefactor = x->invscalefactor;
	double invcurvebase = x->invcurvebase;
	double chirpsize = x->chirpsize;
	double chirp, invchirp;
	double expocurve, invexpocurve;
	double fadeinangle = x->fadeinangle;
	double angle;
	double fadeinwindow;
	
	if(!countdown)	// idle state
	{
		while(blocksize--) 
		{
			*chirpout++ = 0.;
			*invchirpout++ = 0.;
		}
		return (w+5);
	}
	
	if(x->fadein && countup <= x->octavesize) fadein = 1;
	if(x->fadein && (countup >= (x->chirpsize - x->octavesize - blocksize))) invfadein = 1;
	
	while (blocksize--)
	{
		if(countdown)
		{
			expocurve = exp(((double)countup / chirpsize) * logoctavepow);
			chirp = sin(scalefactor * expocurve);
			invexpocurve = exp((((double)countdown) / chirpsize) * logoctavepow); // inverse should start at N, not N-1
			invchirp = sin(scalefactor * invexpocurve);
			invchirp *= invscalefactor * pow(invcurvebase, -(double)countup); // countup+1.?
			
			if(fadein) 
			{
				angle = fadeinangle * countup;
				if(angle > PI) angle = PI;
				fadeinwindow = sin(angle);
				chirp *= fadeinwindow;
			}
			
			if(invfadein)
			{
				angle = fadeinangle * (chirpsize - countup - 1.);
				if(angle > PI) angle = PI;
				fadeinwindow = sin(angle);
				invchirp *= fadeinwindow;
			}
			
			*chirpout = (t_sample)chirp;
			*invchirpout = (t_sample)invchirp;

			countdown--;
			countup++;
		} // end if countdown
		
		else // idle state
		{
			*chirpout = 0.;
			*invchirpout = 0.;
		}

		chirpout++;
		invchirpout++;
	}
	// end of while(blocksize)
	
	x->countdown = countdown;
	x->countup = countup;
	return (w+5);
}
// end of expochirp_perform function definition


static void expochirp_chirpsize(t_expochirp *x)							// compute optimal chirpsize
{
	double angle;
	double octavepow = pow(2., (double)x->octaves);						// 2^octaves
	double ncycles;
	int integercycles;
	double idealchirpsize;
	
	angle = ((PI / octavepow) * x->maxsize) / log(octavepow);
	ncycles = angle / (PI * 2.);
	integercycles = (int)ncycles;										// force number of cycles to integer
	
	if(integercycles < 1) 
	{
		integercycles = 1;
		post("[expochirp~]: maxsize too small for good chirp");
	}
	
	x->scalefactor = integercycles * PI * 2.;								// scalefactor is exact integer multiple of 2*pi
	idealchirpsize = integercycles * octavepow * log(octavepow) * 2.;			// ideal chirpsize, with integer number of cycles
	x->chirpsize = (int)idealchirpsize + 1;								// truncate + 1 = round upwards to make real arraysize
}


static void expochirp_set(t_expochirp *x)
{
	x->logoctavepow = log(pow(2., (double)x->octaves));
	expochirp_chirpsize(x);											// optimal chirpsize must be computed first!
	x->octavesize = x->chirpsize / x->octaves;
	x->fadeinangle = (PI * x->octaves * 0.5) / (double)x->chirpsize;
	x->invcurvebase =  pow(2., ((double)x->octaves / (double)x->chirpsize));
	x->invscalefactor = x->octaves * log(2) / (1. - pow(2.,-x->octaves));
	x->countdown = x->chirpsize;
	clock_delay(x->chirpsizeclock, 0);
}	


static void expochirp_dsp(t_expochirp *x, t_signal **sp)
{
	dsp_add(expochirp_perform, 4, x, sp[0]->s_vec, sp[1]->s_vec, sp[0]->s_n);
}


static void expochirp_bang(t_expochirp *x)
{
	if(x->countdown) return;						// do not restart while busy
	
	x->countup = 0;
	expochirp_set(x);
}


static void expochirp_abort(t_expochirp *x)
{
	x->countdown = 0;							// reset to idle state
}


static void expochirp_octaves(t_expochirp *x, t_floatarg octaves)	
{	
	if(octaves < OCTAVESMIN) octaves = OCTAVESMIN;
	if(octaves > OCTAVESMAX) octaves = OCTAVESMAX;
	x->octaves = (int)octaves;
}	


static void expochirp_maxsize(t_expochirp *x, t_floatarg maxsize)	
{	
	if (maxsize < 0.) maxsize = 0.;
	if (maxsize > (t_floatarg)MAXCHIRPSIZEMAX) 
	{
		x->maxsize = MAXCHIRPSIZEMAX;
		post("[expochirp~]: maximum chirpsize is %d samples", MAXCHIRPSIZEMAX);
	}
	else x->maxsize = (int)maxsize;
}	


static void expochirp_fadein(t_expochirp *x, t_floatarg fadein)
{
	x->fadein = (int)fadein;
}


void expochirp_tilde_setup(void)
{
	expochirp_class = class_new(gensym("expochirp~"), (t_newmethod)expochirp_new, 
		0, sizeof(t_expochirp), 0, A_DEFSYM, 0);
	class_addmethod(expochirp_class, (t_method)expochirp_dsp, gensym("dsp"), 0);
	class_addmethod(expochirp_class, (t_method)expochirp_bang, gensym("bang"), 0);
	class_addmethod(expochirp_class, (t_method)expochirp_abort, gensym("abort"), 0);
	class_addmethod(expochirp_class, (t_method)expochirp_octaves, gensym("octaves"), A_FLOAT, 0);
	class_addmethod(expochirp_class, (t_method)expochirp_maxsize, gensym("maxsize"), A_FLOAT, 0);
	class_addmethod(expochirp_class, (t_method)expochirp_fadein, gensym("fadein"), A_FLOAT, 0);
	
	post("expochirp~ version 0.91 written by Katja Vetter");
}

