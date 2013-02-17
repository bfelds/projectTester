#include <iostream>
#include <unistd.h>

bool test(double val);

int main(int argc, char ** argv)
{
	if(argc<1)
		std::cout << "Please give your executible as the first parameter.";

	int outfd[2];
	int infd[2];

	int oldstdin, oldstdout;

	pipe(outfd); // Where the parent is going to write to
	pipe(infd); // From where parent is going to read

	oldstdin = dup(0); // Save current stdin
	oldstdout = dup(1); // Save stdout

	close(0);
	close(1);

	dup2(outfd[0], 0); // Make the read end of outfd pipe as stdin
	dup2(infd[1],1); // Make the write end of infd as stdout

	pid_t pid = fork();
	if(pid==0) {
		close(0); // Restore the original std fds of parent
		close(1);
		dup2(oldstdin, 0);
		dup2(oldstdout, 1);
		std::cout << "In parent" << std::endl;
		close(outfd[0]); // These are being used by the child
		close(infd[1]);

		//testing
		char input[100]={0};
		write(outfd[1],"1",5);
		read(infd[0],input,100);
		std::cout << input << std::endl;
	}else{
		close(outfd[0]); // Not required for the child
		close(outfd[1]);
		close(infd[0]);
		close(infd[1]);
		char args[1]={0};
		std::cerr << "about to run: " << argv[0]<< std::endl;
		execvp(argv[0],(char**)&args);
	}

	return 0;
}

bool test(double val)
{
	// write(outfd[1],"1",5);

	// input[read(infd[0],input,100)] = 0; // Read from child’s stdout
}