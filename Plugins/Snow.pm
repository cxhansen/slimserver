package Plugins::Snow;

# $Id$
# by Phil Barrett, December 2003
# screensaver conversion by Kevin Deane-Freeman Dec 2003
# graphic SB code added by James Craig September 2005

# This code is derived from code with the following copyright message:
#
# SliMP3 Server Copyright (C) 2001 Sean Adams, Slim Devices Inc.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.
use strict;

###########################################
### Section 1. Change these as required ###
###########################################

use Slim::Control::Request;
use Slim::Utils::Timers;
use Slim::Hardware::VFD;
use File::Spec::Functions qw(:ALL);
use Data::Dumper;

use vars qw($VERSION);
$VERSION = substr(q$Revision$,10);

sub getDisplayName {
	return 'PLUGIN_SCREENSAVER_SNOW';
}

sub strings { return '
PLUGIN_SCREENSAVER_SNOW
	DE	Schnee Bildschirmschoner
	EN	Snow Screensaver
	ES	Salvapantallas de Nieve
	FI	Lumi ruudunsäästäjä
	FR	Ecran de veille Neige
	IT	Salvaschermo Neve
	NL	Sneeuw schermbeveiliger

PLUGIN_SCREENSAVER_SNOW_SETTINGS
	DE	Schnee Einstellungen
	EN	Snow Screensaver settings
	ES	Parámetros para Salvapantallas de Nieve
	FR	Réglages Ecran de veille Neige
	IT	Impostazioni salvaschermo Neve
	NL	Sneeuw schermbeveiliger instellingen

PLUGIN_SCREENSAVER_SNOW_DEFAULT
	DE	Standard-Bildschirmschoner aktivieren
	EN	Use default screensaver (not Snow)
	ES	Utilizar salvapantallas por defecto (No Nieve)
	FR	Utiliser écran de veille par défaut (hors Neige)
	NL	Gebruik standaard schermbeveiliger (niet sneeuw)

PLUGIN_SCREENSAVER_SNOW_QUANTITY
	DE	Schneemenge
	EN	Quantity of snow
	ES	Cantidad de nieve
	FI	Lumen määrä
	FR	Intensité neige
	NL	Hoeveelheid sneeuw

PLUGIN_SCREENSAVER_SNOW_QUANTITY_TITLE
	DE	Schnee Bildschirmschoner: Schneemenge
	EN	Snow Screensaver: Quantity of snow
	ES	Salvapantallas de Nieve: Cantidad de nieve
	FR	Ecran de veille neige: Intensité
	NL	Sneeuw schermbeveiliger: hoeveelheid sneeuw

PLUGIN_SCREENSAVER_SNOW_QUANTITY_0
	DE	Ein paar Schneeflocken
	EN	Light flurries
	ES	Copos livianos
	FI	Kevyitä hiutaleita
	FR	Quelques flocons
	NL	Lichte vlagen

PLUGIN_SCREENSAVER_SNOW_QUANTITY_1
	DE	Weihnächtlich weiss
	EN	Christmassy
	ES	Estilo Navidad
	FR	C\'est Noël !
	NL	Kerstmisachtig

PLUGIN_SCREENSAVER_SNOW_QUANTITY_2
	DE	Heftiges Schneegestöber
	EN	Blizzard
	ES	Tormenta
	FR	Tempête
	NL	Sneeuwstorm

PLUGIN_SCREENSAVER_SNOW_QUANTITY_3
	DE	Dichtes Schneegestöber
	EN	Whiteout
	ES	Resplandor Blanco
	NL	White-out

PLUGIN_SCREENSAVER_SNOW_STYLE
	DE	Schneetyp ein
	EN	Style of snow when on
	ES	Estilo de nieve on
	FI	Lumen tyyli kun päällä
	FR	Type neige on
	NL	Sneeuwstijl indien aan

PLUGIN_SCREENSAVER_SNOW_STYLE_OFF
	DE	Schneetyp aus
	EN	Style of snow when off
	ES	Estilo de nieve off
	FR	Type neige off
	NL	Sneeuwstijl indien uit

PLUGIN_SCREENSAVER_SNOW_STYLE_TITLE
	DE	Schnee Bildschirmschoner: Schneetyp
	EN	Snow Screensaver: Style of snow
	ES	Salvapantallas de Nieve: Estilo de nieve
	FR	Ecran de veille Neige: Type
	NL	Sneeuw schermbeveiliger: sneeuwstijl

PLUGIN_SCREENSAVER_SNOW_STYLE_1
	DE	Es läuft gerade... mit Schnee im Hintergrund
	EN	Now Playing, snow falling behind
	ES	Se está escuchando, la nieve cae detrás
	FR	Lecture + neige en arrière-plan
	IT	Riproduzione in corso, nevicata sullo sfondo
	NL	Speelt nu, sneeuw valt achter

PLUGIN_SCREENSAVER_SNOW_STYLE_2
	DE	Es läuft gerade... mit Schnee im Vordergrund
	EN	Now Playing, snow falling in front
	ES	Se está escuchando, la nieve cae delante
	FR	Lecture +  neige en avant-plan
	IT	Riproduzione in corso, nevicata di fronte
	NL	Speelt nu, sneeuw valt vooraan

PLUGIN_SCREENSAVER_SNOW_STYLE_3
	DE	Datum/Zeit
	EN	Date/Time
	ES	Fecha/Hora
	FR	Date/Heure
	NL	Datum/tijd

PLUGIN_SCREENSAVER_SNOW_STYLE_4
	DE	Nur Schnee
	EN	Just snow
	ES	Solo nieve
	FR	Neige seule
	NL	Alleen sneeuw

PLUGIN_SCREENSAVER_SNOW_STYLE_5
	DE	Automatisch
	EN	Automatic
	ES	Automático
	FR	Automatique
	NL	Automatisch

PLUGIN_SCREENSAVER_SNOW_STYLE_6
	DE	Frohe Feiertage!
	EN	Season\'s Greetings
	ES	Saludos para las Fiestas
	NL	Kerstgroeten

PLUGIN_SCREENSAVER_SNOW_NUMBER_OF_WORDS
	DE	4
	EN	5
	ES	5
	FR	2

PLUGIN_SCREENSAVER_SNOW_WORD_0
	DE	FROHE
	EN	MERRY
	ES	FELIZ
	FR	JOYEUX
	NL	Vrolijk

PLUGIN_SCREENSAVER_SNOW_WORD_1
	DE	WEIHNACHTEN
	EN	CHRISTMAS
	ES	NAVIDAD
	FR	NOEL
	NL	kerstfeest

PLUGIN_SCREENSAVER_SNOW_WORD_2
	DE	UND EIN GUTES
	EN	AND A VERY
	ES	Y UN MUY
	NL	en een heel

PLUGIN_SCREENSAVER_SNOW_WORD_3
	DE	GLÜCKLICHES
	EN	HAPPY
	ES	PRÓSPERO
	NL	gelukkig

PLUGIN_SCREENSAVER_SNOW_WORD_4
	DE	NEUES JAHR!
	EN	NEW YEAR !
	ES	AÑO NUEVO !
	NL	nieuw jaar!

PLUGIN_SCREENSAVER_SNOW_SORRY
	DE	Sorry, Schnee funktioniert auf diesem Gerät nicht.
	EN	Sorry, Snow doesn\'t work with this player.
	ES	Lo siento, la Nieve no funciona en este reproductor.
	IT	Scusa, Neve non funziona con questo lettore.
	NL	Sorry, sneeuw werkt niet op deze speler
'};

##################################################
### Section 2. Your variables and code go here ###
##################################################
our %snow;
our %lastTime;
our %flakes;

# for the player settings menu
#sub setupGroup{
#	my %setupGroup = {
#		PrefOrder => ['plugin_snow_quantity','plugin_snow_style','plugin_snow_style_off'],
#		GroupHed => string(''),
#		GroupDesc => string(''),
#		GroupLine => 1,
#		GroupSub => 1,
#		Suppress_PrefSub => 1,
#		Suppress_PrefLine => 1
#	};
#	
#}

# button functions for browse directory
my @snowSettingsChoices = ('SETUP_SCREENSAVER_USE','PLUGIN_SCREENSAVER_SNOW_QUANTITY', 'PLUGIN_SCREENSAVER_SNOW_STYLE','PLUGIN_SCREENSAVER_SNOW_STYLE_OFF');

our %menuParams = (
	'snow' => {
		'listRef'          => \@snowSettingsChoices,
		'stringExternRef' => 1,
		'header'          => 'PLUGIN_SCREENSAVER_SNOW_SETTINGS',
		'stringHeader'    => 1,
		'headerAddCount'  => 1,
		'callback'        => \&snowExitHandler,
		'overlayRef'      => \&overlayFunc,
		'overlayRefArgs'  => 'C',
	},
	catdir('snow','SETUP_SCREENSAVER_USE') => {
		'useMode'         => 'boolean',
	},
	catdir('snow','PLUGIN_SCREENSAVER_SNOW_QUANTITY') => {
		'useMode'         => 'INPUT.List',
		'listRef'         => [0,1,2,3],
		'externRef'       => ['PLUGIN_SCREENSAVER_SNOW_QUANTITY_0', 'PLUGIN_SCREENSAVER_SNOW_QUANTITY_1', 'PLUGIN_SCREENSAVER_SNOW_QUANTITY_2','PLUGIN_SCREENSAVER_SNOW_QUANTITY_3'],
		'stringExternRef' => 1,
		'header'          => 'PLUGIN_SCREENSAVER_SNOW_QUANTITY_TITLE',
		'stringHeader'    => 1,
		'onChange'        => sub { $_[0]->prefSet('snowQuantity',$_[1]); },
		'onChangeArgs'    => 'CV',
		'initialValue'    => sub { $_[0]->prefGet('snowQuantity'); },
	},
	catdir('snow','PLUGIN_SCREENSAVER_SNOW_STYLE') => {
		'useMode'          => 'INPUT.List',
		'listRef'         => [1,2,3,4,5,6],
		'externRef'       => [ 'PLUGIN_SCREENSAVER_SNOW_STYLE_1','PLUGIN_SCREENSAVER_SNOW_STYLE_2','PLUGIN_SCREENSAVER_SNOW_STYLE_3','PLUGIN_SCREENSAVER_SNOW_STYLE_4','PLUGIN_SCREENSAVER_SNOW_STYLE_5','PLUGIN_SCREENSAVER_SNOW_STYLE_6'],
		'stringExternRef' => 1,
		'header'          => 'PLUGIN_SCREENSAVER_SNOW_STYLE_TITLE',
		'stringHeader'    => 1,
		'onChange'        => sub { $_[0]->prefSet('snowStyle',$_[1]); },
		'onChangeArgs'    => 'CV',
		'initialValue'    => sub { $_[0]->prefGet('snowStyle'); },
	},
	catdir('snow','PLUGIN_SCREENSAVER_SNOW_STYLE_OFF') => {
		'useMode'         => 'INPUT.List',
		'listRef'         => [1,2,3,4,5,6],
		'externRef'       => [ 'PLUGIN_SCREENSAVER_SNOW_STYLE_1','PLUGIN_SCREENSAVER_SNOW_STYLE_2','PLUGIN_SCREENSAVER_SNOW_STYLE_3','PLUGIN_SCREENSAVER_SNOW_STYLE_4','PLUGIN_SCREENSAVER_SNOW_STYLE_5','PLUGIN_SCREENSAVER_SNOW_STYLE_6'],
		'stringExternRef' => 1,
		'header'          => 'PLUGIN_SCREENSAVER_SNOW_STYLE_TITLE',
		'stringHeader'    => 1,
		'onChange'        => sub { $_[0]->prefSet('snowStyleOff',$_[1]); },
		'onChangeArgs'    => 'CV',
		'initialValue'    => sub { $_[0]->prefGet('snowStyleOff'); },
	},
);

sub overlayFunc {
	my $client = shift;
	
	my $saver = Slim::Player::Source::playmode($client) eq 'play' ? 'screensaver' : 'idlesaver';
	
	my $nextmenu = 'snow/' . $client->param('listRef')->[$client->param('listIndex')];
	if (exists($menuParams{$nextmenu})) {
		my %nextParams = %{$menuParams{$nextmenu}};
		
		if ($nextParams{'useMode'} eq 'boolean') {
			return (
				undef,
				Slim::Buttons::Common::checkBoxOverlay(
					$client->prefGet($saver) eq 'SCREENSAVER.snow'
				),
			);
		}
	} else {
		return (undef,Slim::Display::Display::symbol('rightarrow'));
	}
};

sub snowExitHandler {
	my ($client,$exittype) = @_;
	$exittype = uc($exittype);
	if ($exittype eq 'LEFT') {
		Slim::Buttons::Common::popModeRight($client);
	} elsif ($exittype eq 'RIGHT') {
		my $nextmenu = catdir('snow',$snow{$client}->{current});
		if (exists($menuParams{$nextmenu})) {
			my %nextParams = %{$menuParams{$nextmenu}};
			
			if ($nextParams{'useMode'} eq 'boolean') {
				
				my $saver = Slim::Player::Source::playmode($client) eq 'play' ? 'screensaver' : 'idlesaver';
				
				if ($client->prefGet($saver) eq 'SCREENSAVER.snow') {
					$client->prefSet($saver,$Slim::Player::Player::defaultPrefs->{$saver});
				} else {
					$client->prefSet($saver, 'SCREENSAVER.snow');
				}
				
				$client->update();
				return;
			}	
			if ($nextParams{'useMode'} eq 'INPUT.List' && exists($nextParams{'initialValue'})) {
				#set up valueRef for current pref
				my $value;
				if (ref($nextParams{'initialValue'}) eq 'CODE') {
					$value = $nextParams{'initialValue'}->($client);
				} else {
					$value = $client->prefGet($nextParams{'initialValue'});
				}
				$nextParams{'valueRef'} = \$value;
			}
			Slim::Buttons::Common::pushModeLeft(
				$client
				,$nextParams{'useMode'}
				,\%nextParams
			);
		} else {
			$client->bumpRight();
		}
	} else {
		return;
	}
}

our %functions = (
	'right' => sub  {
		my ($client,$funct,$functarg) = @_;
		if (defined($client->param('useMode'))) {
			#in a submenu of settings, which is passing back a button press
			$client->bumpRight();
		} else {
			#handle passback of button presses
			snowExitHandler($client,'RIGHT');
		}
	}
);

sub getFunctions {
	return \%functions;
}

sub setMode {
	my $client = shift;
	my $method = shift;
	if ($method eq 'pop') {
		Slim::Buttons::Common::popMode($client);
		return;
	}

	# install prefs
	$client->prefSet('snowStyle',6)
		unless defined $client->prefGet('snowStyle');
		
	$client->prefSet('snowStyleOff',6)
		unless defined $client->prefGet('snowStyleOff');
		
	$client->prefSet('snowQuantity',1)
		unless defined $client->prefGet('snowQuantity');

	$snow{$client}->{current} = $snowSettingsChoices[0] unless exists($snow{$client}->{current});
	my %params = %{$menuParams{'snow'}};
	$params{'valueRef'} = \$snow{$client}->{current};

	Slim::Buttons::Common::pushMode($client,'INPUT.List',\%params);
	$client->param('modeUpdateInterval', 0.25);
}

###################################################################
### Section 3. Your variables for your screensaver mode go here ###
###################################################################

# First, Register the screensaver mode here.  Must make the call to addStrings in order to have plugin
# localization available at this point.
sub screenSaver {
	Slim::Buttons::Common::addSaver('SCREENSAVER.snow', 
		getScreensaverSnowFunctions(),
		\&setScreensaverSnowMode, 
		\&leaveScreensaverSnowMode,
		'PLUGIN_SCREENSAVER_SNOW',
	);
}

our %screensaverSnowFunctions = (
	'done' => sub  {
		my ($client, $funct, $functarg) = @_;
		
		Slim::Buttons::Common::popMode($client);
		$client->update();
		#pass along ir code to new mode if requested
		
		if (defined $functarg && $functarg eq 'passback') {
			Slim::Hardware::IR::resendButton($client);
		}
	}
	# disable this so you can change the size of text
	#,'textsize' => sub { 
	#	my $client = shift;
	#	$snow{$client}->{wasDoubleSize} = !$snow{$client}->{wasDoubleSize}; 
	#}
);

sub getScreensaverSnowFunctions {
	return \%screensaverSnowFunctions;
}

sub setScreensaverSnowMode {
	my $client = shift;
	$client->param('modeUpdateInterval', 0.25);
	$client->lines(\&screensaverSnowlines);
	
	#$snow{$client}->{wasDoubleSize} = $client->textSize;
	#$client->textSize(0);

	#check power status
	if ($client->power()) {
		# save time on later lookups - we know these can't change while we're active
		$snow{$client}->{snowStyle} = $client->prefGet('snowStyle') || 6;
	} else {
		$snow{$client}->{snowStyle} = $client->prefGet('snowStyleOff') || 6;
	}
	$snow{$client}->{snowQuantity} = $client->prefGet('snowQuantity') || 1;
	if ($client->isa( "Slim::Player::Squeezebox2")) {
		$snow{$client}->{clientType} = 'SB2';
	} elsif  ($client->isa( "Slim::Player::SqueezeboxG" )) {
		$snow{$client}->{clientType} = 'SBG';
	} else {
		$snow{$client}->{clientType} = 'SB1';
	}
}

sub leaveScreensaverSnowMode {
	my $client = shift;
	#$client->textSize($snow{$client}->{wasDoubleSize});
	#$lastTime{$client} = Time::HiRes::time();
}

sub screensaverSnowlines {
	my $client = shift;
	my $lines;
	my $onlyInSpaces = 0;
	my $simple = 0;
	my $words = 0;
	my $style = $snow{$client}->{snowStyle};

	if($style == 5) {
		# automatic
		if (Slim::Player::Source::playmode($client) eq "pause") {
			$style = 4; # Just snow when paused
		
		} elsif (Slim::Player::Source::playmode($client) eq "stop") {
			$style = 4; # Just snow when stopped
		
		} else {
			$style = 1; # Now Playing when playing
		}
	}

	if($style == 6) {
		$style = 4; # Just snow
		$words = 2; # With words
	}

	if($style == 1 || $style == 2) {
		# Now Playing
		$lines = $client->renderOverlay($client->currentSongLines());
		$onlyInSpaces = ($style == 1);
	
	} elsif($style == 3) {
		# Date/Time
		$lines = $client->renderOverlay(&Slim::Buttons::Common::dateTime($client));
		$onlyInSpaces = 1;
	
	} else {
		# Just snow
		$simple = 1;
	}

	return letItSnow($client, $lines, $onlyInSpaces, $simple, $words);
}

sub insertChar {
	my $line = shift;
	my $sym = shift;
	my $col = shift;
	my $len = shift;
	return ($col > 0 ? Slim::Display::Display::subString($line, 0, $col) : '') . 
		$sym .
		($col < (40-$len) ? Slim::Display::Display::subString($line, $col+$len, 40 - $len - $col) : '');
}

Slim::Hardware::VFD::setCustomChar('snow01',
                                 ( 0b00000010,
                                   0b00000111,
                                   0b00000010,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow00',
                                 ( 0b00001000,
                                   0b00011100,
                                   0b00001000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow11',
                                 ( 0b00000000,
                                   0b00000000,
                                   0b00000010,
                                   0b00000111,
                                   0b00000010,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow10',
                                 ( 0b00000000,
                                   0b00000000,
                                   0b00001000,
                                   0b00011100,
                                   0b00001000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow21',
                                 ( 0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000010,
                                   0b00000111,
                                   0b00000010,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow20',
                                 ( 0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00000000,
                                   0b00001000,
                                   0b00011100,
                                   0b00001000,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow7',
                                 ( 0b00001000,
                                   0b00011100,
                                   0b00001000,
                                   0b00000000,
                                   0b00001000,
                                   0b00011100,
                                   0b00001000,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow8',
                                 ( 0b00000000,
                                   0b00000000,
                                   0b00001000,
                                   0b00011100,
                                   0b00001010,
                                   0b00000111,
                                   0b00000010,
                                   0b00000000 ));
Slim::Hardware::VFD::setCustomChar('snow9',
                                 ( 0b00001000,
                                   0b00011100,
                                   0b00001000,
                                   0b00000000,
                                   0b00000010,
                                   0b00000111,
                                   0b00000010,
                                   0b00000000 ));

our %flakeMap = (0 => ' ',
	1  => Slim::Display::Display::symbol('snow00'),
	2  => Slim::Display::Display::symbol('snow10'),
	4  => Slim::Display::Display::symbol('snow20'),
	5  => Slim::Display::Display::symbol('snow7'),
	8  => Slim::Display::Display::symbol('snow01'),
	16 => Slim::Display::Display::symbol('snow11'),
	32 => Slim::Display::Display::symbol('snow21'),
	33 => Slim::Display::Display::symbol('snow9'),
	34 => Slim::Display::Display::symbol('snow8'),
);
		
# SBG is 280x16, so we create a 6x16 blank and tack an empty column on in the render function
my $blankG=
	"\x00\x00".
	"\x00\x00".
	"\x00\x00";
	
my $flakeG_1=
	"\x20\x00".
	"\x70\x00".
	"\x20\x00";
	
my $flakeG_2=
	"\x08\x00".
	"\x1c\x00".
	"\x08\x00";
	
my $flakeG_3=
	"\x02\x00".
	"\x07\x00".
	"\x02\x00";
	
my $flakeG_4=
	"\x00\x20".
	"\x00\x70".
	"\x00\x20";
	
my $flakeG_5=
	"\x00\x08".
	"\x00\x1c".
	"\x00\x08";
	
my $flakeG_6=
	"\x00\x02".
	"\x00\x07".
	"\x00\x02";
		
our %flakeMapG = (
	0 => $blankG   . $blankG,
	
	1 => $flakeG_1,
	2 => $flakeG_2,
	3 =>($flakeG_2 | $flakeG_1),
	4 => $flakeG_3,
	5 =>($flakeG_3 | $flakeG_1),
	6 =>($flakeG_3 | $flakeG_2),
	7 =>($flakeG_3 | $flakeG_2 | $flakeG_1),
 
	65=> $flakeG_4,
	66=> $flakeG_5,
	67=>($flakeG_5 | $flakeG_4),
	68=> $flakeG_6,
	69=>($flakeG_6 | $flakeG_4),
	70=>($flakeG_6 | $flakeG_5),
	71=>($flakeG_6 | $flakeG_5 | $flakeG_4),
);

#SB2 is 320x32 so we create an 4x32 blank
our $blank2 = 
	"\x00\x00\x00\x00".
	"\x00\x00\x00\x00".
	"\x00\x00\x00\x00".
	"\x00\x00\x00\x00";

our $flake2s_1 =
	"\x04\x00\x00\x00".
	"\x0e\x00\x00\x00".
	"\x04\x00\x00\x00".
	"\x00\x00\x00\x00";
our $flake2s_2 = 
	"\x00\x40\x00\x00".
	"\x00\xe0\x00\x00".
	"\x00\x40\x00\x00".
	"\x00\x00\x00\x00";
our $flake2s_3= 
	"\x00\x04\x00\x00".
	"\x00\x0e\x00\x00".
	"\x00\x04\x00\x00".
	"\x00\x00\x00\x00";
our $flake2s_4=  
	"\x00\x00\x04\x00".
	"\x00\x00\x0e\x00".
	"\x00\x00\x04\x00".
	"\x00\x00\x00\x00";
our $flake2s_5=  
	"\x00\x00\x00\x40".
	"\x00\x00\x00\xe0".
	"\x00\x00\x00\x40".
	"\x00\x00\x00\x00";
our $flake2s_6= 
	"\x00\x00\x00\x04".
	"\x00\x00\x00\x0e".
	"\x00\x00\x00\x04".
	"\x00\x00\x00\x00";

our $flake2m_1=
	"\xa8\x00\x00\x00".
	"\x70\x00\x00\x00".
	"\xa8\x00\x00\x00".
	"\x00\x00\x00\x00";
our $flake2m_2=
	"\x05\x40\x00\x00".
	"\x03\x80\x00\x00".
	"\x04\x40\x00\x00".
	"\x00\x00\x00\x00";
our $flake2m_3=
	"\x00\x15\x00\x00".
	"\x00\x0e\x00\x00".
	"\x00\x15\x00\x00".
	"\x00\x00\x00\x00";
our $flake2m_4=
	"\x00\x00\xa8\x00".
	"\x00\x00\x70\x00".
	"\x00\x00\xa8\x00".
	"\x00\x00\x00\x00";
our $flake2m_5 =
	"\x00\x00\x05\x40".
	"\x00\x00\x03\x80".
	"\x00\x00\x04\x40".
	"\x00\x00\x00\x00";
our $flake2m_6 =
	"\x00\x00\x00\x15".
	"\x00\x00\x00\x0e".
	"\x00\x00\x00\x15".
	"\x00\x00\x00\x00";

our @flakeMap2 = (
	#small flakes
	{
	0 => $blank2,
	1 => $flake2s_1,
	2 => $flake2s_2,
	3 =>($flake2s_2 | $flake2s_1),
	4 => $flake2s_3,
	5 =>($flake2s_3 | $flake2s_1),
	6 =>($flake2s_3 | $flake2s_2),
	7 =>($flake2s_3 | $flake2s_2 | $flake2s_1),
	65=> $flake2s_4,
	66=> $flake2s_5,
	67=>($flake2s_5 | $flake2s_4),
	68=> $flake2s_6,
	69=>($flake2s_6 | $flake2s_4),
	70=>($flake2s_6 | $flake2s_5),
	71=>($flake2s_6 | $flake2s_5 | $flake2s_4),
	},
	
	{
	#medium flakes
	0 => $blank2,
	
	1 => $flake2m_1,
	2 => $flake2m_2,   
	3 =>($flake2m_2 | $flake2m_1),
	4 => $flake2m_3,
	5 =>($flake2m_3 | $flake2m_1),
	6 =>($flake2m_3 | $flake2m_2),
	7 =>($flake2m_3 | $flake2m_2 | $flake2m_1),
	
	65=> $flake2m_4,
	66=> $flake2m_5,
	67=>($flake2m_5 | $flake2m_4),
	68=> $flake2m_6,
	69=>($flake2m_6 | $flake2m_4),
	70=>($flake2m_6 | $flake2m_5),
	71=>($flake2m_6 | $flake2m_5 | $flake2m_4),
	},

);

our %letters = (
	A => [3, [2], [], [0,4], [0,2,4], [], [0,4] ],
	B => [3, [0,2], [4], [0,2], [0], [4], [0,2] ],
	C => [3, [2,4], [1], [], [1], [], [2,4] ],
	D => [3, [0,2], [4], [0], [0,4], [], [0,2] ],
	E => [3, [0,2,4], [], [0,2], [0], [], [0,2,4] ],
	F => [3, [0,2,4], [], [0], [0,2], [], [0] ],
	G => [3, [2,4], [1], [], [1,4], [], [2,4] ],
	H => [3, [0,4], [], [0,2,4], [0,4], [], [0,4] ],
	I => [1, [0], [], [0], [0], [], [0] ],
	J => [3, [0,2,4], [], [2], [2], [0], [1,2] ],
	K => [3, [0,4], [], [0,2], [0,3], [], [0,4] ],
	L => [3, [0], [], [0], [0], [], [0,2,4] ],
	M => [4, [0,6], [2,4], [0,3,6], [0,6], [], [0,6] ],
	N => [3, [0,4], [], [0,2,4], [0,3,4], [], [0,4] ],
	O => [3, [2], [], [0,4], [0,4], [], [2] ],
	P => [3, [0,2], [], [0,4], [0,2], [], [0] ],
	Q => [3, [2], [], [0,4], [0,4], [], [2,5] ],
	R => [3, [0,2], [], [0,4], [0,2], [], [0,4] ],
	S => [3, [2,4], [1], [2], [4], [], [1,3] ],
	T => [3, [0,2,4], [], [2], [2], [], [2] ],
	U => [4, [0,5], [], [0,5], [0,5], [], [2,3] ],
	#V => [4, [0,6], [], [1,5], [2,4], [], [3] ],
	V => [3, [0,4], [], [0,4], [1,3], [], [2] ],
	W => [3, [0,4], [], [0,2,4], [0,2,4], [], [1,3] ],
	X => [3, [0,4], [], [1,3], [2,4], [], [0,5] ],
	Y => [3, [0,4], [], [1,3], [2], [], [2] ],
	Z => [3, [0,2,4], [], [3], [2], [], [0,2,4] ],
	' ' => [0, [], [], [], [], [], [] ],
	'!' => [1, [0], [], [0], [], [], [0] ],
);
		
#sub drawFlake {
#    my $bigrow = shift;
#    my $bigcol = shift;
#    my $torender = shift;
#    my $onlyIfCanRender = shift;
#    my $onlyInSpaces = shift;
#    my $lines = shift;
#
#    my $row = int($bigrow / 3);
#    my $line = "line".$row+1;
#    my $col = int($bigcol / 2);
#    
#    my $sym = Slim::Display::Display::symbol('snow' . ($bigrow - $row * 3) . ($bigcol - $col * 2));
#    
#    if( !$onlyInSpaces || Slim::Display::Display::subString($lines->{"$line"}, $col, 1) eq ' ') {
#		$lines->{"$line"} = insertChar($lines->{"$line"}, $sym, $col, 1);
#    }
#}

# paint a single flake in the torender structure
sub paintFlake {
	my $bigrow = shift;
	my $bigcol = shift;
	my $torender = shift;
	my $onlyIfCanRender = shift;
	my $onlyInSpaces = shift;
	my $lines = shift;
	
	##let the snow pile up on the bottom;
	#$bigrow = 5 if ($bigrow > 5);
	
	my $row = int($bigrow / 3);
	my $line = "line".$row+1;
	my $col = int($bigcol / 2);

	my $bit = (1 << (($bigrow - $row * 3) + 3 * ($bigcol - $col * 2)));

	if(! $onlyInSpaces or Slim::Display::Display::subString($lines->{$line}, $col, 1) eq ' ') {
		if($torender->[$row][$col] != -1) {
			return 0 if($onlyIfCanRender && !exists($flakeMap{($torender->[$row][$col]) | $bit}));
			$torender->[$row][$col] |= $bit;
		} else {
			$torender->[$row][$col] = $bit;
		}
		return 1;
	}
	return 0;
}

sub renderFlakes {
	my $client = $_[0];

	if( $client ) {
		if ($snow{$client}->{clientType} eq 'SB2') {
			return renderGraphicFlakes2(@_);
		} elsif  ($snow{$client}->{clientType} eq 'SBG') {
			return renderGraphicFlakes(@_);
		} else {
			return renderCharFlakes(@_);
		}
	}
}

sub renderGraphicFlakes2 {
	my $client = shift;
	my $torender = shift;
	my $lines = shift;
	
	my $onlyInSpaces = 0; #too tricky for for graphic displays! 

	#place the flakes in $torender
	my %flakeSize;
	foreach my $flake (@{$flakes{$client}}) {
		paintFlake(@{$flake}[0], @{$flake}[1], $torender, 1, $onlyInSpaces, $lines);
		$flakeSize{int(@{$flake}[0]/3).substr('0'.@{$flake}[1],-2)} = @{$flake}[2] if  (@{$flake}[2] != 0);
	}

	$lines->{bits} = '';
	my $blank = $flakeMap2[0]{0}; 
	foreach my $col (0..39) {
		my $flakeSize;
		my $char;
		my $top = $torender->[0][$col];
		my $bottom = $torender->[1][$col];
		$top = 0 if ($top == -1);
		$bottom = 0 if ($bottom == -1);

		my $leftcol=substr('0'.($col*2),-2);
		my $rightcol=substr('0'.($col*2)+1,-2);

		#left column
		$char = $blank;
		$flakeSize = $flakeSize{"0$leftcol"} || 0;
		$char |= $flakeMap2[$flakeSize]{$top & 7};
		$flakeSize = $flakeSize{"1$leftcol"} || 0;
		$char |= $flakeMap2[$flakeSize]{64|($bottom & 7)};
		$lines->{bits} .= $char;
		#right column
		$char = $blank;
		$flakeSize = $flakeSize{"0$rightcol"} || 0;
		$char |= $flakeMap2[$flakeSize]{$top>>3};
		$flakeSize = $flakeSize{"1$rightcol"} || 0;
		$char |= $flakeMap2[$flakeSize]{64|($bottom>>3)};
		$lines->{bits} .= $char;
	}

	return $lines;
}

sub renderGraphicFlakes {
	my $client = shift;
	my $torender = shift;
	my $lines = shift;
	
	my $onlyInSpaces = 0; #too tricky for for graphic displays! 

	#place the flakes in $torender
	foreach my $flake (@{$flakes{$client}}) {
		paintFlake(@{$flake}[0], @{$flake}[1], $torender, 1, $onlyInSpaces, $lines);
	}
	
	$lines->{bits} = '';
	my $blank = $flakeMapG{0}; 
	foreach my $col (0..39) {
		my $top = $torender->[0][$col];
		my $bottom = $torender->[1][$col];
		$top = 0 if ($top == -1);
		$bottom = 0 if ($bottom == -1);	
		#left column
		$lines->{bits} .= $blank | $flakeMapG{$top & 7} | $flakeMapG{64|($bottom & 7)};
		#right column
		$lines->{bits} .= $blank | $flakeMapG{$top>>3} | $flakeMapG{64|($bottom>>3)};
		#add an empty column
		$lines->{bits} .= "\x00\x00";
	}

	return $lines;
}

sub renderCharFlakes {
	my $client = shift;
	my $torender = shift;
	my $lines = shift;
	my $onlyInSpaces = shift;
	my $row;
	my $col;
	my @oldlines = ($lines->{line1},$lines->{line2});
	my @newlines = ('', '');
	
	#place the flakes in $torender
	foreach my $flake (@{$flakes{$client}}) {
		paintFlake(@{$flake}[0], @{$flake}[1], $torender, 1, $onlyInSpaces, $lines);
	}
	
	foreach $row (0,1) {
		foreach $col (0..39) {
			my $bits = $torender->[$row][$col];
			if($bits == -1) {
				$newlines[$row] .= Slim::Display::Display::subString($oldlines[$row], $col, 1);
			} elsif(exists $flakeMap{$bits}) {
				$newlines[$row] .= $flakeMap{$bits};
			} else {
				print "No symbol for $bits\n";
				$newlines[$row] .= '*';
			}
		}
	}

	$lines->{line1} = $newlines[0];
	$lines->{line2} = $newlines[1];
	return $lines;
}

my $holdTime = 70;

sub paintWord {
	my $word = shift;
	my $state = shift;
	my $offsets = shift;
	my $torender = shift;
	my $lines = shift;
	my @text;
	my $letter;
	my $row;
	my $col;
	
	my $totallen = -1;
	map {$totallen += @{$letters{$_}}[0] + 1} (split //, $word);
	
	my $startcol = 2 * int((40 - $totallen) / 2);
	
	# Wipe out any falling snow under the letters
	foreach $row (0..1) {
		foreach $col (0..($totallen-1)) {
			$torender->[$row][$startcol/2+$col] = 0;
		}
	}
	
	my $exiting = 0;
	if($state > $holdTime) {
		$state -= $holdTime;
		$exiting = 1;
	}

	my $paintedSomething = 0;

	foreach $letter (split //, $word) {
		
		my $charwidth = @{$letters{$letter}}[0];
		foreach $row (0..5) {
		
		foreach $col (@{$letters{$letter}[$row+1]}) {
				my $outrow = 3 * $row - 15 + $state - $offsets->[int($col/2)];
		
				if(!$exiting) {
					$outrow = $row if($outrow > $row); # stop at correct row
				} else {
					$outrow = $row if($outrow < $row); # start at correct row
				}
		
				if($outrow >= 0 && $outrow < 6) {
					paintFlake($outrow, $startcol + $col, $torender, 0, 0, $lines);
					$paintedSomething = 1;
				}
			}
		}
		$startcol += $charwidth * 2 + 2;
	}

	return $paintedSomething;
}

our %wordState;
our %word;
our %offsets;
our %wordIndex;

sub letItSnow {
	my $client = shift;
	my $lines = shift;
	my $onlyInSpaces = shift;
	my $simple = shift;
	my $showWords = shift;

	my $flake;
	foreach $flake (@{$flakes{$client}}) {
		$flake->[0] ++;
		#flakes on the ground don't move
		$flake->[1] += (int(rand(3)) - 1) if ($flake->[0] < 6);
	}
		
	# cull flakes which have left the screen
	@{$flakes{$client}} = grep { $_->[0] < 6 && $_->[1] >= 0 && $_->[1] < 80} @{$flakes{$client}};
		
	for (0..5) {
		if(rand(100) < (5,10,30,100)[$snow{$client}->{snowQuantity}]) {
			push @{$flakes{$client}}, [0, int rand(80), int rand(2)];
		}
	}

	# pad centre lines (do we even need this any more?)
	foreach my $i ("line1","line2") {
		if(!$simple) {
			if (index($lines->{$i}, Slim::Display::Display::symbol('center') ) == 0)  {
				$lines->{$i} = substr($lines->{$i}, length(Slim::Display::Display::symbol('center')));
				s/\s*$//;
				my $centerspaces = int((40-Slim::Display::Display::lineLength($lines->{$i}))/2);
				$lines->{$i} = (" " x $centerspaces).$lines->{$i};
			}
		}
		# this was truncating scrolling display at 40 characters
		if ($snow{$client}->{clientType} eq 'SB1') {
			$lines->{$i} = Slim::Display::Display::subString($lines->{$i} . (' ' x 40), 0, 40);
		}
	}

	#initialise the flake position structure
	my $torender = [[-1,-1], [-1,-1]];
	foreach my $row (0..1) {
		foreach my $col (0..39) {
			$torender->[$row][$col] = -1;
		}
	}
	
	# add the christmas words
	if($showWords) {
		if(!exists $wordState{$client}) {
			$wordState{$client} = -1; 
			$wordIndex{$client} = 0;
		}
		
		if($wordState{$client} == -1) {
			# Not showing a word right now. Should we start next time?
			$word{$client} = $client->string('PLUGIN_SCREENSAVER_SNOW_WORD_' . $wordIndex{$client});
			$wordIndex{$client}++;
			$wordIndex{$client} = 0 if($wordIndex{$client} == $client->string('PLUGIN_SCREENSAVER_SNOW_NUMBER_OF_WORDS'));
			$wordState{$client} = 0;
			
			foreach my $col (0..39) {
				$offsets{$client}->[$col] = int(rand(24));
			}
		} else {
			my $paintedSomething = paintWord($word{$client}, $wordState{$client}, $offsets{$client}, $torender, $lines);
			$wordState{$client} ++;#if($animate);
			
			if($wordState{$client} > $holdTime && !$paintedSomething) {
				# finished with this word. Resume normal snowing
				$wordState{$client} = -1;
			}
		}
	}
	
	#render the flakes
	$lines = renderFlakes($client,$torender, $lines, $onlyInSpaces);
	
	return $lines;
}

1;

__END__
