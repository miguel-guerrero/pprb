//>  incl_file  "corpus/ex.vh" 

    :while: (x < 5) {
        :if: (a == 1) {
            :if: (b == 1) {
                x = 1;
            } {
                x = 2;
            }
        } {
            :if: (b == 2) {
                x = 3;
            } {
                x = 4;
            }
        }
    }
