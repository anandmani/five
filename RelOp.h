#ifndef REL_OP_H
#define REL_OP_H

#include "Pipe.h"
#include "DBFile.h"
#include "Record.h"
#include "Function.h"

struct thread_utils{
	DBFile inFile;
	Pipe *inPipe;
	Pipe *outPipe;
	CNF selOperator;
	Record literal;
	Function computeMe;
};

class RelationalOp {
	public:
	// blocks the caller until the particular relational operator 
	// has run to completion
	virtual void WaitUntilDone () = 0;

	// tell us how much internal memory the operation can use
	virtual void Use_n_Pages (int n) = 0;
};

class SelectFile : public RelationalOp { 

private:
	pthread_t thread;
	//Record *buffer;
	int runLength;

public:

	void Run (DBFile &inFile, Pipe &outPipe, CNF &selOp, Record &literal);
	void WaitUntilDone ();
	void Use_n_Pages (int n);
	static void *ReadFromDBFile(void *args);

};

class SelectPipe : public RelationalOp {
	pthread_t thread;
	//Record *buffer;
	int runLength;

public:
	void Run(Pipe &inPipe, Pipe &outPipe, CNF &selOp, Record &literal);
	void WaitUntilDone();
	void Use_n_Pages(int n);
	static void *ReadFromPipe(void *args);
};


class Project : public RelationalOp { 
pthread_t thread;
int runLength;
public:
	void Run(Pipe &inPipe, Pipe &outPipe, int *keepMe, int numAttsInput, int numAttsOutput);
	void WaitUntilDone();
	void Use_n_Pages(int n);
};


class Join : public RelationalOp { 

private:
	pthread_t thread;
	Pipe *inPipeL;
	Pipe *inPipeR;
	Pipe *outPipe;
	CNF *selOp;
	Record *literal;
	int nPages;
public:
	void Run(Pipe &inPipeL, Pipe &inPipeR, Pipe &outPipe, CNF &selOp, Record &literal);
	void WaitUntilDone();
	void join();
	static void* jswpn(void *);
	void Use_n_Pages(int n){}
};
class DuplicateRemoval : public RelationalOp {

private:
	pthread_t thread;
	int runLength;
	Pipe *inPipe;
	Pipe *outPipe;
	Schema *mySchema;

public:
	void Run(Pipe &inPipe, Pipe &outPipe, Schema &mySchema);
	void WaitUntilDone();
	void Use_n_Pages(int n);
	static void *DupRemovalThread(void *args);
};
class Sum : public RelationalOp {

private:
	int runLength;
	pthread_t thread;

public:
	void Run(Pipe &inPipe, Pipe &outPipe, Function &computeMe);
	void WaitUntilDone();
	void Use_n_Pages(int n);
	static void *ComputeSum(void *args);
};
class GroupBy : public RelationalOp {

private:
	int runLength;
	pthread_t thread;
	Pipe *inPipe;
	Pipe *outPipe;
	OrderMaker *groupAtts;
	Function *computeMe;
	Schema *grpSchema;

public:
	void Run(Pipe &inPipe, Pipe &outPipe, OrderMaker &groupAtts, Function &computeMe);
	void WaitUntilDone();
	void Use_n_Pages(int n);
	static void *GroupByThread(void *args);
};
class WriteOut : public RelationalOp {

private:
	int runLength;
	pthread_t thread;
	Pipe *inPipe;
	Schema *mySchema;
	FILE *outFile;

public:
	void Run (Pipe &inPipe, FILE *outFile, Schema &mySchema);
	void WaitUntilDone();
	void Use_n_Pages(int n);
	static void *WriteToFile(void *args);
};
#endif
