#!/usr/bin/perl
use File::Spec;
use File::Basename;
use File::Which;
use Cwd 'abs_path';

$run_path = File::Spec->rel2abs($0);
$run_dir = dirname($run_path);
chdir($run_dir);

my $exe_path = which 'extempore';
my $exe_dir;

if (defined($exe_path) && (-f $exe_path))
{
	$exe_dir = dirname(abs_path($exe_path));
} elsif (-f "/Applications/extempore/extempore") {
	$exe_dir = "/Applications/extempore";
} else {
	print "Couldn't find extempore - you can specify 'path_to_extempore' in info.txt";
}

print $exe_dir;
chdir($exe_dir);


# audio device selection
my @audio_devices = `$exe_path --print-devices`;
print @audio_devices;

# my $jack_device_number;
#
# foreach my $device_line (@devices)
# {
# 	if ($device_line =~ /device\[(\d+)\]:Jack/)
# 	{
# 		$jack_device_number = $1;
# 	}
# }


print "\nSelect audio output: ";
my $audio_device_number = <STDIN>;
chomp $audio_device_number;
#print $audio_device_number;

# midi device selection
print "\nScanning MIDI devices ... \n";
# my $cmd2 = "$exe_path --eval '(sys:load \"libs/external/portmidi.xtm\") (quit 0)'";
my $cmd2 = "$exe_path --run=$run_dir/midi-devices.xtm";
print "$cmd2\n";
my @midi_devices = system($cmd2);
print @midi_devices;

print "\nSelect midi input: ";
my $midi_input_device_number = <STDIN>;
chomp $midi_input_device_number;

print "\nSelect midi output: ";
my $midi_output_device_number = <STDIN>;
chomp $midi_output_device_number;



my $cmd;
if (defined ($audio_device_number)) {
	$cmd = "$exe_path --device=$audio_device_number --midi-in=$midi_input_device_number --midi-out=$midi_output_device_number --run='$run_dir/runner.xtm'";
} else {
	$cmd = "$exe_path --midi-in=$midi_input_device_number --midi-out=$midi_output_device_number --run='$run_dir/runner.xtm'";
}
print "\n $cmd \n";
exec($cmd);
