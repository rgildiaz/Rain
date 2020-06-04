// 209 Final Project

// Boot the server
(
// Server.local.options.sampleRate_(44100);
// Set this to 48000 for zoom
Server.local.options.sampleRate_(48000);

s.boot;
)

s.reboot;

// SynthDefs
// Random
(
SynthDef.new(\rand, {
	arg atk=10, rel=10, amp=0.7, peak=1, pan=0;
	var sig, env, wave, freq;
	env = EnvGen.kr(
		Env.new([0.001, peak, 0.001], [atk, rel], [1.5, \exp]),
		doneAction:2
	);
	wave = SinOsc.kr({ExpRand(0.2, 12)}).range(0,1);
	freq = LinRand(40, 2000);
	sig = SinOsc.ar(freq);
	sig = sig * wave * env;
	sig = FreeVerb.ar(sig, 0.5, 0.75);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;
)

(
SynthDef.new(\randClose, {
	arg freq=440, atk=10, rel=10, amp=0.7, peak=1, pan=0;
	var sig, env, wave;
	env = EnvGen.kr(
		Env.new([0.001, peak, 0.001], [atk, rel], [1.5, \exp]),
		doneAction:2
	);
	wave = SinOsc.kr({ExpRand(0.2, 12)}).range(0,1);
	sig = SinOsc.ar(ExpRand(220, 440));
	sig = sig * wave * env;
	sig = FreeVerb.ar(sig, 0.5, 0.75);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;
)

// Tonal
(
SynthDef.new(\chords, {
	arg freq=440, atk=10, rel=10, amp=0.7, peak=1, pan=0;
	var sig, env, wave;
	env = EnvGen.kr(
		Env.new([0.001, peak, 0.001], [atk, rel], [1.5, \exp]),
		doneAction:2
	);
	wave = SinOsc.kr({ExpRand(0.2, 12)}).range(0,1);
	sig = SinOsc.ar(freq, mul: wave * env);
	sig = FreeVerb.ar(sig, 0.5, 0.75);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;
)

(
SynthDef.new(\melody, {
	arg freq=440, len=20, amp=0.7, peak=1, pan=0, out;
	var sig, env, atk, rel;
	atk = len / 2;
	rel = len / 2;
	env = EnvGen.kr(
		Env.new([0.001, peak, 0.001], [atk, rel], [1.5, \exp]),
		doneAction:2
	);
	sig = LFPulse.ar(Vibrato.ar(DC.ar(freq), 1, 0.001), mul: env);
	sig = BPF.ar(sig, freq, 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

// Effects
(
SynthDef.new(\melodyEffects, {
	arg in=9, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.7, 0.95);
	Out.ar(out, sig);
}).add;
)

// Background
(
~b0 = Buffer.read(s, "C:/Users/rgild/OneDrive/Desktop/209 Final Project/background rain splice long.wav");
SynthDef.new(\background, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate,doneAction: 2);
	sig = sig * amp;
	sig = Splay.ar(sig);
	Out.ar(0, sig);
}).add;
)



// Patterns
// Effects
(
Pdef(
	\melEf,
	Pbind(
		\instrument, \melodyEffects,
		\dur, inf,
		\in, 9,
		\out, 0,
	);
).play;
)

// Background
(
Pdef(
	\bg,
	Pbind(
		\instrument, \background,
		\dur, inf,
		\amp, 0.85,
	);
).play;
)

// Random
(
Pdef(
	\randpat,
	Pbind(
		\instrument, \rand,
		\dur, Pwhite(1, 3, inf),
		\atk, Pexprand(8, 15, inf),
		\rel, Pexprand(8, 10, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
		\amp, Pwhite(0.5, 0.65, inf),
	);
).stop;
)


(
Pdef(
	\randclosepat,
	Pbind(
		\instrument, \randClose,
		\dur, Pwhite(1, 3, inf),
		\atk, Pexprand(8, 15, inf),
		\rel, Pexprand(8, 10, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
		\amp, Pwhite(0.5, 0.65, inf),
	);
).stop;
)

// Tonal
(
Pdef(
	\closechordpat,
	Pbind(
		\instrument, \chords,
		\dur, Pwhite(1.5, 3, inf),
		\atk, Pexprand(8, 15, inf),
		\rel, Pexprand(8, 10, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
		\amp, Pwhite(0.5, 0.65, inf),
		\freq, Prand(
			(
				(Scale.dorian.degrees + 69) ++
				[81, 69]
		).midicps,
		inf),
	);
).stop;
)

(
Pdef(
	\farchordpat,
	Pbind(
		\instrument, \chords,
		\dur, Pwhite(1.5, 3, inf),
		\atk, Pexprand(8, 15, inf),
		\rel, Pexprand(8, 10, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
		\amp, Pwhite(0.5, 0.65, inf),
		\freq, Prand(
			(
				(Scale.dorian.degrees + 69) ++
				(Scale.dorian.degrees + 57) ++
				(Scale.dorian.degrees + 45) ++
				[81, 69, 69, 57, 45, 52, 64, 64, 71, 72, 74, 76]
			).midicps,
			inf),
		\peak, Pexprand(0.75, 1, inf),
	);
).stop;
)

(
Pdef(
	\melody,
	Pbind(
		\instrument, \melody,
		\freq, Prand(
			(
				(Scale.dorian.degrees + 69) ++
				[69, 76, 81, 86]
			).midicps,
			inf),
		\len, Prand(
			[2, 4, 4, 6, 8, 8],
			inf),
		\dur, Pkey(\len, inf),
		\pan, 0,
		\amp, 0.65,
		\peak, Pexprand(0.7, 1),
		\out, 9,
	);
).stop;
)

// Recording
s.prepareForRecord(numChannels: 2);
s.record();
s.stopRecording();