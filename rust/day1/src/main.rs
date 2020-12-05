use std::fs;

fn main() {
    let contents = fs::read_to_string("expenses.txt")
        .expect("Can't find file");
    
    let expenses = contents.split("\n");

    let mut exp: Vec<i32> = Vec::new();

    for e in expenses {
        let mut es: String = e.to_string();
        es.pop();
        if !es.is_empty() {
            let ei: i32 = es.parse::<i32>().unwrap();
            //println!("{}",ei);
            exp.push(ei);
    
        }
    }

'out: for i in 0..exp.len() {
        let e1 = exp[i];
        for e in 0..exp.len() {
            if e == i {
                continue;
            }
            let e2 = exp[e];
            if (e1+e2) == 2020 {
                println!("The answer is: {}",e1*e2);
                break 'out;
            }
        }
    }
    for i in 0..exp.len() {
        let e1 = exp[i];
        for e in 0..exp.len() {
            if e == i {
                continue;
            }
            let e2 = exp[e];
            for j in 0..exp.len() {
                if j == e {
                    continue;
                }
                let e3 = exp[j];
                if (e1+e2+e3) == 2020 {
                    println!("The answer is: {}",e1*e2*e3);
                    return;
                }
            }
        }
    }
}
