/*
  modules/TIBCO/tibco-module.cc

  TIBCO integration to QORE

  Qore Programming Language

  Copyright 2003 - 2010 David Nichols

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include "tibae-module.h"

#include "QC_TibcoAdapter.h"

#include <string.h>

void init_tibae_constants(QoreNamespace&);
void init_tibae_functions(QoreNamespace&);

DLLEXPORT char qore_module_name[] = "tibae";
DLLEXPORT char qore_module_version[] = PACKAGE_VERSION;
DLLEXPORT char qore_module_description[] = "TIBCO Active Enterprise module";
DLLEXPORT char qore_module_author[] = "David Nichols";
DLLEXPORT char qore_module_url[] = "http://qore.org";
DLLEXPORT int qore_module_api_major = QORE_MODULE_API_MAJOR;
DLLEXPORT int qore_module_api_minor = QORE_MODULE_API_MINOR;
DLLEXPORT qore_module_init_t qore_module_init = tibae_module_init;
DLLEXPORT qore_module_ns_init_t qore_module_ns_init = tibae_module_ns_init;
DLLEXPORT qore_module_delete_t qore_module_delete = tibae_module_delete;
DLLEXPORT qore_license_t qore_module_license = QL_LGPL;

static QoreNamespace tibns("Tibae");

static void setup_namespace() {
   // setup static "master" namespace
   tibns.addSystemClass(initTibcoAdapterClass());

   init_tibae_constants(tibns);
   init_tibae_functions(tibns);
}

QoreStringNode* tibae_module_init() {
   setup_namespace();
   return NULL;
}

void tibae_module_ns_init(QoreNamespace* rns, QoreNamespace* qns) {
   QORE_TRACE("tibae_module_ns_init()");
   qns->addInitialNamespace(tibns.copy());
}

void tibae_module_delete() {
   QORE_TRACE("tibae_module_delete()");
}
