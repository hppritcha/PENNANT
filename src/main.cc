/*
 * main.cc
 *
 *  Created on: Jan 23, 2012
 *      Author: cferenba
 *
 * Copyright (c) 2012, Triad National Security, LLC.
 * All rights reserved.
 * Use of this source code is governed by a BSD-style open-source
 * license; see top-level LICENSE file for full license text.
 */

#include <cstdlib>
#include <string>
#include <iostream>

#include "Parallel.hh"
#include "InputFile.hh"
#include "Driver.hh"
#include "armie-utils.h"

using namespace std;

#if 0
#define __START_TRACE() { asm volatile (".inst 0x2520e020"); }
#define __STOP_TRACE() { asm volatile (".inst 0x2520e040"); }
#endif

int main(int argc, char** argv)
{
    __INIT_ARMIE(argv[0]);
    Parallel::init();

    if (argc != 2) {
        if (Parallel::mype == 0)
            cerr << "Usage: pennant <filename>" << endl;
        exit(1);
    }

    const char* filename = argv[1];
    InputFile inp(filename);

    string probname(filename);
    // strip .pnt suffix from filename
    int len = probname.length();
    if (probname.substr(len - 4, 4) == ".pnt")
        probname = probname.substr(0, len - 4);

    Driver drv(&inp, probname);

    drv.run();

    Parallel::final();

    return 0;

}



